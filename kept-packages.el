(require 'package)

(defvar kept-packages-file-name "~/.emacs.d/kept-packages")

(defun kept-packages-save ()
  (with-temp-file kept-packages-file-name
    (dolist (p package-activated-list)
      (insert (prin1-to-string p))
      (newline))))

(defun kept-packages-load ()
  (with-temp-buffer
    (when (condition-case nil (insert-file-contents kept-packages-file-name) (error nil))
      (while (< (point) (point-max))
        (let ((package-name (buffer-substring (line-beginning-position)
                                              (line-end-position))))
          (unless (package-installed-p (read package-name))
            (message (concat "installing " package-name))
            (package-install (read package-name))))
        (goto-char (line-beginning-position 2))))))

(eval-after-load "kept-packages"
  '(progn
     (package-initialize)

     (unless package-archive-contents
       (package-refresh-contents))

     (kept-packages-load)
     (add-hook 'after-init-hook
               'kept-packages-save)))

(provide 'kept-packages)
