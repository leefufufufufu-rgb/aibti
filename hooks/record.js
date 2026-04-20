#!/usr/bin/env node
/**
 * AIBTI · UserPromptSubmit Hook (Node.js version · zero dependencies)
 *
 * Writes each prompt to ~/.aibti/prompts.jsonl with basic redaction.
 * Silent on error — never blocks user input.
 *
 * Why Node.js: Claude Code already ships with Node, so no extra install.
 * Runs on macOS / Linux / Windows out of the box.
 */
'use strict';

const fs = require('fs');
const path = require('path');
const os = require('os');

const AIBTI_DIR = path.join(os.homedir(), '.aibti');
const OUT = path.join(AIBTI_DIR, 'prompts.jsonl');

function redact(text) {
    return text
        .replace(/\b[\w.+-]+@[\w-]+\.[\w.-]+\b/g, '<EMAIL>')
        .replace(/\b(sk-[A-Za-z0-9]{20,}|ant-[A-Za-z0-9_-]{20,})\b/g, '<API_KEY>')
        .replace(/\b(?:1[3-9]\d{9}|\+?1?\d{10})\b/g, '<PHONE>');
}

async function readStdin() {
    return new Promise((resolve) => {
        let data = '';
        process.stdin.setEncoding('utf8');
        process.stdin.on('data', (chunk) => { data += chunk; });
        process.stdin.on('end', () => resolve(data));
        process.stdin.on('error', () => resolve(''));
        setTimeout(() => resolve(data), 1500); // safety cutoff
    });
}

(async () => {
    try {
        const raw = await readStdin();
        if (!raw) return;

        let payload;
        try { payload = JSON.parse(raw); } catch { return; }

        const text = (payload.prompt || '').trim();
        if (!text || text.length < 2) return;

        if (!fs.existsSync(AIBTI_DIR)) {
            fs.mkdirSync(AIBTI_DIR, { recursive: true, mode: 0o700 });
        }

        const record = {
            ts: new Date().toISOString(),
            src: 'claude-code',
            session_id: payload.session_id || '',
            cwd: payload.cwd || '',
            text: redact(text),
            len_char: text.length,
        };

        fs.appendFileSync(OUT, JSON.stringify(record) + '\n', { encoding: 'utf8' });
    } catch {
        // silent fail — never block user
    }
})();
