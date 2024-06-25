// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

let Hooks = {}

Hooks.SwitchCatForms = {
    mounted() {
        this.el.addEventListener("dblclick", () => {
            let id = this.el.id;
            let del = document.getElementById("del_" + id);
            let upd = document.getElementById("upd_" + id);
            if (del && upd) {
                del.style.display = "none";
                upd.style.display = "flex";
            }
        })
    }
}

Hooks.SwitchSubForms = {
    mounted() {
        this.el.addEventListener("dblclick", () => {
            let id = this.el.id;
            let del = document.getElementById("del_" + id);
            let upd = document.getElementById("upd_" + id);
            if (del && upd) {
                del.style.display = "none";
                upd.style.display = "flex";
            }
        })
    }
}

Hooks.EnableOnCreateSelectButton = {
    mounted() {
        console.log("DOING SHIT")
        let select = document.getElementById("info_form_select_btn-s");
        let btn_id = "info_form_select_btn-sb";
        select.addEventListener("change", () => {
            document.getElementById(btn_id).disabled = (
                select.options[select.selectedIndex].value != "create"
                && this.el.dataset.equipment == ""
            );
        })
    }
}

function changeBtnText(id) {
    let btn_id = id + "b";
    let select = document.getElementById(id);
    document.getElementById(btn_id).innerText = select.options[select.selectedIndex].text;
    document.getElementById(btn_id).value = select.value;
}

Hooks.SelectButtonOnChange = {
    mounted() {
        this.el.addEventListener("change", () => {
            changeBtnText(this.el.id);
        })

        changeBtnText(this.el.id);
    },
    updated() {
        changeBtnText(this.el.id);
    }
}

let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

