# Emacs / dired-w32-open
This package provides a function `dired-w32-open`.
This function executes files selected on dired buffer by a windows associated program.

This package has developped because convenient function `w32-shell-execute` cannot open multiple files at the same time.

# Setting example
`
(define-key dired-mode-map (kbd "J") 'dired-w32-open)
`