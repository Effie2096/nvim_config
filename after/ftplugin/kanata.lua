local ft = require("Comment.ft")

vim.bo.commentstring = ";; %s"

ft.set("kanata", { ';; %s', '#| %s |#' })
