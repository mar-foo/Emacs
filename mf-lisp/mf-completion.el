;;; mf-completion.el --- Configuration for the completion framework -*- lexical-binding: t -*-
;;; Code:
(setq tab-always-indent 'complete)
(autoload 'ffap-file-at-point "ffap")
(defun complete-path-at-point+ ()
  "Return completion data for UNIX path at point."
  (let ((fn (ffap-file-at-point))
        (fap (thing-at-point 'filename)))
    (when (and (or fn (equal "/" fap))
               (save-excursion
                 (search-backward fap (line-beginning-position) t)))
      (list (match-beginning 0)
            (match-end 0)
            #'completion-file-name-table :exclusive 'no))))
(add-hook 'completion-at-point-functions
          #'complete-path-at-point+
          'append)

(setq completion-styles '(substring partial-completion initials flex)
	  completion-category-overrides
	  '((file (styles initials basic))))

(mf/install vertico)
(eval-after-load 'minibuffer
  '(progn
	 (message "Loaded vertico")
	 (vertico-mode 1)))

(mf/install company)
(unless
	(fboundp #'company-mode)
  (autoload #'company-mode "company" nil t))
(eval-after-load 'lsp-mode
  '(progn
	 (add-hook 'lsp-mode-hook 'company-mode)
	 (eval-after-load 'company
	   '(progn
		  (message "Company loaded")
		  (define-key company-active-map (kbd "<tab>") #'company-complete-selection)
		  (define-key lsp-mode-map (kbd "<tab>") #'company-indent-or-complete-common)
		  (setq company-minimum-prefix-length 3
				company-idle-delay nil)))))

(provide 'mf-completion)
;;; mf-completion.el ends here
