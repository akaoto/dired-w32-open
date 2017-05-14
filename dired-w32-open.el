;;; dired-w32-open.el --- Open files by a windows  associated program via dired  -*- lexical-binding: t; -*-

;; Copyright (C) 2017  akaoto

;; Author: Akaoto <akaoto@outlook.com>
;; Keywords: dired, windows, associated program
;; Version: 0.0.1
;; URL: https://github.com/akaoto/dired-w32-open

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; Marking files on dired and calling dired-w32-open execute the files by a windows associated file.
;; If no marked files, the function executes a file getting the cursor.

;;; Code:

(defun split-extension (file-name)
  (string-match ".*\\(\\..*\\)" file-name)
  (match-string 1 file-name))

(defun escape-file-name (file-name)
  (concat "\"" file-name "\""))

(defun query-progid (extension)
  (let* ((query-command (concat
                         "reg query HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\"
                         extension
                         "\\UserChoice /v ProgId"))
         (ret (shell-command-to-string query-command)))
    (string-match "ProgId\s+REG_SZ\s+\\(.*\\)" ret)
    (match-string 1 ret)))

(defun query-assoc (progid)
  (let* ((ret (shell-command-to-string (concat "ftype " progid))))
    (if (string-match ".*=\"\\(.*\\)\"\s" ret)
        (match-string 1 ret)
      "LaunchWinApp")))

(defun query-associated-program (file-name)
  (let* ((extension (split-extension file-name))
         (progid (query-progid extension))
         (assoc (query-assoc progid)))
    assoc))


;;;###autoload
(defun dired-w32-open ()
  (interactive)
    (let* ((file-names (dired-get-marked-files))
         (prog (query-associated-program (car file-names)))
         (cmd (mapconcat 'escape-file-name (cons prog file-names) " ")))
      ;; (async-shell-command cmd nil nil)))
      (call-process-shell-command cmd nil 0 nil)))

(provide 'dired-w32-open)

;;; dired-w32-open.el ends here
