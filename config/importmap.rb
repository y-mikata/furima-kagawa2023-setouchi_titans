# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "calc", to: "calc.js"
pin "card", to: "card.js"
pin "preview", to: "preview.js"
pin "gallery", to: "gallery.js"
pin "el-transition", to: "el-transition.js"
pin "initialize-payjp", to: "initialize-payjp.js"
pin "/assets/initialize-payjp", to: "initialize-payjp"
