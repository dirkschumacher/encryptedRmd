'use strict'

const {decrypt} = require('sodium-encryption')
const {saveAs} = require('file-saver')

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
    const html = new Blob([msg], {
      type: 'text/html;charset=utf-8'
    })
    saveAs(html, 'document.html')
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
