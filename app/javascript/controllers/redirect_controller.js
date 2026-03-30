import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  visit({ params: { url } }) {
    window.location.href = url
  }
}
