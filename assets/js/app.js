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
import Uploaders from "./uploaders"
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

function changeBtnText(id) {
    let btn_id = id + "-sb";
    let select = document.getElementById(id + "-s");
    document.getElementById(btn_id).innerText = select.options[select.selectedIndex].text;
    document.getElementById(btn_id).value = select.value;
}

Hooks.SelectButtonOnChange = {
    mounted() {
        document.getElementById(this.el.id + "-s").addEventListener("change", () => {
            changeBtnText(this.el.id);
            this.el.dispatchEvent(new Event("select_button_custom"))
        })

        changeBtnText(this.el.id);
    },
    updated() {
        changeBtnText(this.el.id);
    }
}

Hooks.SelectInput = {
    mounted() {
        let input = document.getElementById(this.el.id + "-i")
        input.addEventListener("focus", () => {
            document.querySelector("body").style.overflow = "hidden";
            first = true;
            let options = Array.from(document.querySelectorAll(".select-input-li-" + this.el.id));
            for (var item of options) {
                if (item.innerHTML.toLowerCase().includes(input.value.toLowerCase())) {
                    item.style.display = "block";
                    if (first) {
                        item.dataset.selected = "true";
                        item.classList.add("select-input-li-selected");
                        first = false
                    } else  {
                        item.dataset.selected = "false";
                        item.classList.remove("select-input-li-selected");
                    }
                } else {
                    item.style.display = "none";
                }
            }

            document.getElementById(this.el.id + "-l").style.display = "block";
            let rect = this.el.getBoundingClientRect();
            if (rect.bottom + document.getElementById(this.el.id + "-l").offsetHeight > (window.innerHeight || document.documentElement.clientHeight)) {
                document.getElementById(this.el.id + "-l").style.bottom = "calc(0px + 100%)";
            } else {
                document.getElementById(this.el.id + "-l").style.bottom = "";
            }
        });

        input.addEventListener("focusout", () => {
            document.querySelector("body").style.overflow = "scroll";
            document.getElementById(this.el.id + "-l").style.display = "none";
            if (document.getElementById(this.el.id + "-h").value == "") {
                document.getElementById(this.el.id + "-i").value = "";
            }
        });

        input.addEventListener("keyup", (e) => {
            if (["ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight", "Enter"].includes(e.code)) { return; }
            document.getElementById(this.el.id + "-h").value = "";
            let options = Array.from(document.querySelectorAll(".select-input-li-" + this.el.id));
            let first = true;
            for (var item of options) {
                if (item.innerHTML.toLowerCase().includes(input.value.toLowerCase())) {
                    item.style.display = "block";
                    if (first) {
                        item.dataset.selected = "true";
                        item.classList.add("select-input-li-selected");
                    } else {
                        item.dataset.selected = "false";
                        item.classList.remove("select-input-li-selected");
                    }
                    first = false;
                } else {
                    item.style.display = "none";
                }
            }
        });

        input.addEventListener("keydown", (e) => {
            let options = Array.from(document.querySelectorAll(".select-input-li-" + this.el.id));
            function goto(list) {
                let previous = false;
                list.forEach((item, i) => {
                    if (item.dataset.selected == "true" && i < list.length - 1) { 
                        previous = true;
                        item.dataset.selected = "false";
                        item.classList.remove("select-input-li-selected");
                    } else if (previous) {
                        item.dataset.selected = "true";
                        item.classList.add("select-input-li-selected");
                        previous = false;
                    }
                });
            }

            if (e.code == "ArrowDown") {
                goto(options);
            } else if (e.code == "ArrowUp") {
                goto(options.reverse());
            } else if (e.code == "Enter") {
                options.forEach((item) => {
                    if (item.dataset.selected == "true") {
                        item.dataset.selected = "false";
                        document.getElementById(this.el.id + "-i").value = item.innerHTML;
                        document.getElementById(this.el.id + "-h").value = item.dataset.value;
                        document.getElementById(this.el.id + "-i").dispatchEvent(new Event("change", {bubbles: true}));
                        document.getElementById(this.el.id + "-i").blur();
                    }
                })
            } else if (e.code == "Escape") {
                document.getElementById(this.el.id + "-i").dispatchEvent(new Event("change", {bubbles: true}));
                document.getElementById(this.el.id + "-i").blur();
            }
        });


        let options = Array.from(document.querySelectorAll(".select-input-li-" + this.el.id));
        for (var item of options) {
            item.addEventListener("mousedown", (e) => {
                document.getElementById(this.el.id + "-i").value = e.target.innerHTML;
                document.getElementById(this.el.id + "-h").value = e.target.dataset.value;
                document.getElementById(this.el.id + "-i").dispatchEvent(new Event("change", {bubbles: true}));
            });

            item.addEventListener("mouseover", (e) => {
                let options = Array.from(document.querySelectorAll(".select-input-li-" + this.el.id));
                for (var item of options) {
                    item.dataset.selected = false;
                    item.classList.remove("select-input-li-selected");
                }
                e.target.dataset.selected = true;
                e.target.classList.add("select-input-li-selected");
            });
        }
    },
    updated() {
        for (var item of document.querySelectorAll(".select-input-li-" + this.el.id)) {
            item.addEventListener("mousedown", (e) => {
                document.getElementById(this.el.id + "-i").value = e.target.innerHTML;
                document.getElementById(this.el.id + "-h").value = e.target.dataset.value;
                document.getElementById(this.el.id + "-i").dispatchEvent(new Event("change", {bubbles: true}));
            });

            item.addEventListener("mouseover", (e) => {
                let options = Array.from(document.querySelectorAll(".select-input-li-" + this.el.id));
                for (var item of options) {
                    item.dataset.selected = false;
                    item.classList.remove("select-input-li-selected");
                }
                e.target.dataset.selected = true;
                e.target.classList.add("select-input-li-selected");
            });

            if (document.getElementById(this.el.id + "-h").value == item.dataset.value) {
                document.getElementById(this.el.id + "-i").value = item.innerHTML;
            }
        }

        if (document.getElementById(this.el.id + "-h").value == "") {
            document.getElementById(this.el.id + "-i").value = "";
        }
    }
}

let liveSocket = new LiveSocket("/live", 
    Socket, {
        params: {_csrf_token: csrfToken}, 
        hooks: Hooks,
        uploaders: Uploaders
    }
)

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

