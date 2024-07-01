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
    updated() {
        let select = document.getElementById("info-form-select-btn-s");
        let btn_id = "info-form-select-btn-sb";
        document.getElementById(btn_id).disabled = (
            select.options[select.selectedIndex].value != "create"
            && this.el.dataset.equipment == ""
        );
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

Hooks.SelectInput = {
    mounted() {
        let input = document.getElementById(this.el.id + "-i")
        input.addEventListener("focus", () => {
            first = true;
            for (var item of document.querySelectorAll(".select-input-li")) {
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
            document.getElementById(this.el.id + "-l").style.opacity = "100";
        });

        input.addEventListener("focusout", () => {
            document.getElementById(this.el.id + "-l").style.opacity = "0";
            if (document.getElementById(this.el.id + "-h").value == "") {
                input.value = "";
            }
        });

        input.addEventListener("keyup", (e) => {
            if (["ArrowUp", "ArrowDown", "Enter"].includes(e.code)) { return; }
            document.getElementById(this.el.id + "-h").value = "";
            let first = true;
            for (var item of document.querySelectorAll(".select-input-li")) {
                if (item.innerHTML.toLowerCase().includes(input.value.toLowerCase())) {
                    item.style.display = "block";
                    if (first) {
                        item.dataset.selected = "true";
                        item.classList.add("select-input-li-selected");
                    } else {
                        item.dataset.selected = "flase";
                        item.classList.remove("select-input-li-selected");
                    }
                    first = false;
                } else {
                    item.style.display = "none";
                }
            }
        });

        input.addEventListener("keydown", (e) => {
            let previous = false;
            let options = Array.from(document.querySelectorAll(".select-input-li"));
            function goto(list) {
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
                        document.getElementById(this.el.id + "-i").blur();
                        document.getElementById(this.el.id + "-i").value = item.innerHTML;
                        document.getElementById(this.el.id + "-h").value = item.dataset.value;
                        document.getElementById(this.el.id + "-l").style.opacity = "0";
                    }
                })
            } else if (e.code == "Escape") {
                options.forEach((item) => {
                    document.getElementById(this.el.id + "-i").blur();
                    document.getElementById(this.el.id + "-i").value = "";
                    document.getElementById(this.el.id + "-h").value = "";
                    document.getElementById(this.el.id + "-l").style.opacity = "0";
                })
            }
        });

        for (var item of document.querySelectorAll(".select-input-li")) {
            item.addEventListener("mousedown", (e) => {
                document.getElementById(this.el.id + "-i").value = e.target.innerHTML;
                document.getElementById(this.el.id + "-h").value = e.target.dataset.value;
            });

            item.addEventListener("mouseover", (e) => {
                for (var item of document.querySelectorAll(".select-input-li")) {
                    item.dataset.selected = false;
                    item.classList.remove("select-input-li-selected");
                }
                e.target.dataset.selected = true;
                e.target.classList.add("select-input-li-selected");
            });
        }
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

