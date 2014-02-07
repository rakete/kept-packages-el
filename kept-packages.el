(defvar kept-packages-file-name "~/.emacs.d/kept-packages")

(defun kept-packages-save ()
  (with-temp-file kept-packages-file-name
    (dolist (p package-activated-list)
      (insert (prin1-to-string p))
      (newline))))

(defun kept-packages-load ()
  (with-temp-buffer
    (insert-file-contents kept-packages-file-name)
    (while (< (point) (point-max))
      (let ((package-name (buffer-substring (line-beginning-position)
                                            (line-end-position))))
        (unless (package-installed-p (read package-name))
          (message (concat "installing " package-name))
          (package-install (read package-name))))
      (goto-char (line-beginning-position 2)))))

(provide 'kept-packages)
