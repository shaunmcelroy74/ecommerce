import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="products"
export default class extends Controller {
  static values = { product: Object }

  addToCart() {
    console.log("product: ", this.productValue)
  }
}