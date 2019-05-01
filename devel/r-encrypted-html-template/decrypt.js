// Based on the work of Jannis R. The original code is licensed ISC.
// https://github.com/derhuerst/self-decrypting-html-page

// Copyright (c) 2018, Jannis R

// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

'use strict'

const {decrypt} = require('sodium-encryption')

const keyEl = document.getElementById('key')
const submitEl = document.getElementById('submit')
const messageEl = document.getElementById('message')

const resetForm = () => {
  keyEl.classList.remove('error')
  submitEl.classList.remove('error')
  messageEl.innerText = ''
}

const showError = (el, message) => {
  el.classList.add('error')
  messageEl.innerText = message
}

const onSubmit = () => {
  resetForm()

  try {
    if (keyEl.value.length === 0) {
      return showError(keyEl, 'Please enter a key.')
    }
    const key = Buffer.from(keyEl.value, 'hex')
    const msg = decrypt(encrypted, nonce, key)
    document.write(msg)
  } catch (err) {
    console.error(err)
    showError(submitEl, 'The key seems to be wrong.')
  }
}

const nonceEl = document.getElementById('nonce')
const encryptedEl = document.getElementById('encrypted')
let encrypted = null, nonce = null
if (nonceEl && nonceEl.innerText && encryptedEl && encryptedEl.innerText) {
  nonce = Buffer.from(nonceEl.innerText, 'hex')
  encrypted = Buffer.from(encryptedEl.innerText, 'hex')
  submitEl.addEventListener('click', onSubmit, false)
} else {
  showError(submitEl, 'Encrypted data missing.')
  keyEl.disabled = nonceEl.disabled = submitEl.disabled = true
}
