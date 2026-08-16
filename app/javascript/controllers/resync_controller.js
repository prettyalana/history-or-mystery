import { Controller } from "@hotwired/stimulus"

// Keeps the page from showing stale content when the Action Cable / Turbo
// Streams connection dies without any visible sign of it.
//
// Mobile browsers suspend or drop WebSocket connections when the tab is
// backgrounded, the phone is locked, or the page is restored from the
// back-forward cache (bfcache) — visibilitychange/pageshow catch that case.
//
// But a mobile carrier's network can also silently drop an idle connection
// even while the tab stays fully visible and awake, with no browser event
// to react to. The interval below catches that case by resyncing on a
// fixed schedule regardless of visibility.
export default class extends Controller {
  static RESYNC_INTERVAL_MS = 25000

  connect() {
    this.handleVisibilityChange = this.handleVisibilityChange.bind(this)
    this.handlePageShow = this.handlePageShow.bind(this)

    document.addEventListener("visibilitychange", this.handleVisibilityChange)
    window.addEventListener("pageshow", this.handlePageShow)

    this.interval = setInterval(() => this.resync(), this.constructor.RESYNC_INTERVAL_MS)
  }

  disconnect() {
    document.removeEventListener("visibilitychange", this.handleVisibilityChange)
    window.removeEventListener("pageshow", this.handlePageShow)

    clearInterval(this.interval)
  }

  handleVisibilityChange() {
    if (document.visibilityState === "visible") {
      this.resync()
    }
  }

  handlePageShow(event) {
    if (event.persisted) {
      this.resync()
    }
  }

  resync() {
    if (this.resyncing) return
    this.resyncing = true

    Turbo.visit(window.location.href, { action: "replace" })

    setTimeout(() => {
      this.resyncing = false
    }, 500)
  }
}
