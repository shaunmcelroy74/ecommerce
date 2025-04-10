// app/javascript/controllers/cart_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.renderCart()
  }

  renderCart() {
    const cart = JSON.parse(localStorage.getItem("cart") || "[]")
    const itemsEl       = this.element.querySelector("#items")
    const totalItemsEl  = this.element.querySelector("#total-items")
    const totalAmountEl = this.element.querySelector("#total-amount")

    itemsEl.innerHTML = ""
    let totalCents = 0
    let totalItems = 0

    if (cart.length === 0) {
      itemsEl.innerHTML = "<p>Your cart is empty.</p>"
      totalItemsEl.innerText  = ""
      totalAmountEl.innerText = ""
      return
    }

    cart.forEach(item => {
      totalCents += item.price * item.quantity
      totalItems += item.quantity

      const row = document.createElement("div")
      row.classList.add("flex", "items-center", "gap-4")

      // 1) Show current quantity
      const qtySpan = document.createElement("span")
      qtySpan.innerText = `Qty: ${item.quantity}`

      // 2) Product name & price
      const desc = document.createElement("span")
      desc.innerText = `${item.name} — $${(item.price/100).toFixed(2)}`

      // 3) Input for new quantity
      const qtyInput = document.createElement("input")
      qtyInput.type  = "number"
      qtyInput.min   = "1"
      qtyInput.value = item.quantity
      qtyInput.classList.add("border", "rounded", "px-2", "py-1", "w-16")

      // 4) Update button that *sets* the new quantity
      const updateBtn = document.createElement("button")
      updateBtn.innerText = "Update"
      updateBtn.classList.add("bg-green-500", "text-white", "px-2", "py-1", "rounded")
      updateBtn.addEventListener("click", () => {
        const newQty = parseInt(qtyInput.value, 10)
        this.setQuantity(item.id, newQty)
      })

      // 5) Remove button
      const removeBtn = document.createElement("button")
      removeBtn.innerText = "Remove"
      removeBtn.classList.add("bg-gray-500", "text-white", "px-2", "py-1", "rounded")
      removeBtn.addEventListener("click", () => this.removeFromCart(item.id))

      row.append(qtySpan, desc, qtyInput, updateBtn, removeBtn)
      itemsEl.appendChild(row)
    })

    totalAmountEl.innerText = `Total: $${(totalCents/100).toFixed(2)}`
  }

  setQuantity(id, newQty) {
    if (newQty < 1) return
    const cart = JSON.parse(localStorage.getItem("cart") || "[]")
    const idx  = cart.findIndex(i => i.id === id)
    if (idx > -1) {
      // **set** the new quantity, not add
      cart[idx].quantity = newQty
      localStorage.setItem("cart", JSON.stringify(cart))
      this.renderCart()
    }
  }

  removeFromCart(id) {
    let cart = JSON.parse(localStorage.getItem("cart") || "[]")
    cart = cart.filter(i => i.id !== id)
    localStorage.setItem("cart", JSON.stringify(cart))
    this.renderCart()
  }

  clear() {
    localStorage.removeItem("cart")
    this.renderCart()
  }

  checkout() {
    alert("Proceeding to checkout…")
  }
}
