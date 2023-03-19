;; -*- lexical-binding: t; -*-
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default))
 '(package-selected-packages
   '(affe consult-lsp vertico-prescient consult vertico flycheck rainbow-delimiters company-prescient prescient lsp-latex auto-package-update key-chord lsp-haskell yaml-mode dockerfile-mode lua-mode lsp-ui ledger-mode htmlize cmake-mode rust-mode haskell-mode go-mode lsp-mode spacemacs-theme exec-path-from-shell org-bullets evil-mc evil-snipe yasnippet-snippets yasnippet evil-matchit evil-nerd-commenter evil-surround company evil magit use-package)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq inhibit-startup-screen t)

;; (let ((file-name-handler-alist nil)) user-init-file)

(load-theme 'spacemacs-dark)

;; global key bindings
(global-set-key [f5] (lambda() (interactive) (revert-buffer t t)))
(global-set-key [f6] (lambda() (interactive) (find-file user-init-file)))
(global-set-key [remap list-buffers] 'buffer-menu-other-window)

(require 'use-package-ensure)
(setq use-package-always-ensure t)
;; (setq use-package-verbose t)

(eval-when-compile
  (require 'use-package))

(use-package emacs
  :ensure nil
  :init
  (setq frame-title-format '("%b"))
  (setq-default tab-width 4)
  (setq-default indent-tabs-mode nil)
  (setq scroll-step 1)
  (setq scroll-margin 10)
  (setq scroll-conservatively 999)
  (setq enable-recursive-minibuffers t)
  (setq read-process-output-max (* 1024 1024))
  (fset 'yes-or-no-p 'y-or-n-p))

(use-package frame
  :ensure nil
  :init
  (set-frame-font "SourceCodePro 14" nil t)
  (blink-cursor-mode 0))

(use-package files
  :ensure nil
  :init
  (setq backup-directory-alist
        `((".*" . ,temporary-file-directory)))
  (setq auto-save-file-name-transforms
        `((".*" ,temporary-file-directory t))))

(use-package elec-pair
  :ensure nil
  :config (electric-pair-mode t))

(use-package calendar
  :ensure nil
  :defer t
  :config (setq calendar-week-start-day 1))

(use-package dired
  :ensure nil
  :hook (dired-mode . dired-hide-details-mode)
  :bind ("C-c d" . dired-jump)
  :config
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies 'always))

(use-package recentf
  :ensure nil
  :config (recentf-mode 1))

(use-package org
  :ensure nil
  :hook (org-mode . visual-line-mode)
  :bind
  ("C-c a" . org-agenda)
  ("C-c c" . org-capture)
  :config
  (setq org-startup-folded 'showall)
  (setq org-startup-indented 1)
  (setq org-directory "~/.local/share/Cryptomator/mnt/nextcloud/org")
  (setq org-agenda-files (list "inbox.org" "agenda.org"))
  (setq org-agenda-hide-tags-regexp ".")
  (setq org-capture-templates
        '(("i" "Inbox" entry (file "inbox.org")
          "* TODO %?\nEntered on %U"))))

(use-package ox
  :defer t
  :ensure nil
  :config
  (setq org-export-with-author nil)
  (setq org-export-with-creator nil)
  (setq org-export-with-date nil))

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :config
  (setq exec-path-from-shell-arguments nil)
  (exec-path-from-shell-initialize))

(use-package rainbow-delimiters
  :hook (prog-mode))

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package vertico
  :init
  (vertico-mode))

(use-package consult
  :bind
  ("C-s" . consult-line)
  ("C-x b" . consult-buffer)
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq xref-show-definitions-function #'consult-xref)
  (setq xref-show-xrefs-function #'consult-xref))

(use-package prescient
  :config (prescient-persist-mode 1))

(use-package vertico-prescient
  :after (prescient vertico)
  :config (vertico-prescient-mode 1))

(use-package affe
  :bind
  ("C-c g" . affe-grep)
  ("C-c f" . affe-find)
  :config
  (setq affe-find-command "fd --hidden --type file"))

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  :config
  (defun evil-insert-new-line-normal-mode ()
    (interactive)
    (evil-open-below 1)
    (evil-normal-state)
    (message ""))
  (evil-mode 1)
  (evil-set-initial-state 'dired-mode 'emacs)
  (evil-set-initial-state 'ledger-report-mode 'emacs)
  (evil-set-initial-state 'flycheck-error-list-mode 'emacs)
  (evil-set-initial-state 'Buffer-menu-mode 'emacs)
  (setq evil-vsplit-window-right t)
  (setq evil-mode-line-format 'nil)
  (with-eval-after-load 'evil-maps
    (define-key evil-motion-state-map [down-mouse-1] nil))
  :bind (:map evil-normal-state-map
              ("gc" . evilnc-comment-or-uncomment-lines)
              ("gs" . magit-status)
              ("gel" . flycheck-list-errors)
              ("gen" . flycheck-next-error)
              ("gep" . flycheck-previous-error)
              ("gt" . affe-find)
              ("ga" . affe-grep)
              ("gb" . consult-buffer)
              ("RET" . evil-insert-new-line-normal-mode)
              ;; neo bindings
              ("r" . evil-next-line)
              ("j" . evil-replace)
              ("t" . evil-previous-line)
              ("k" . evil-snipe-t)
              :map evil-visual-state-map
              ("r" . evil-next-line)
              ("j" . evil-replace)
              ("t" . evil-previous-line)
              ("k" . evil-snipe-t)))

(use-package evil-surround
  :config (global-evil-surround-mode 1))

(use-package evil-snipe
  :config
  (setq evil-snipe-smart-case 1)
  (evil-snipe-mode +1)
  (evil-snipe-override-mode +1))

(use-package evil-matchit
  :config (global-evil-matchit-mode 1))

(use-package evil-mc
  :config (global-evil-mc-mode 1))

(use-package key-chord
  :config
  (key-chord-mode 1)
  (setq key-chord-two-keys-delay 0.5)
  (key-chord-define evil-insert-state-map "hh" 'evil-normal-state))

(use-package yasnippet
  :hook ((prog-mode . yas-minor-mode)
         (latex-mode . yas-minor-mode))
  :config (yas-reload-all))

(use-package org-bullets
  :hook (org-mode))

(use-package lsp-mode
  :hook ((c++-mode . lsp)
         (go-mode . lsp)
         (haskell-mode . lsp)
         (rust-mode . lsp)
         (latex-mode . lsp)
         (typescript-mode . lsp))
  :init (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-symbol-highlighting-skip-current t)
  (setq lsp-response-timeout 25)
  (setq lsp-file-watch-threshold nil))

(use-package lsp-ui
  :hook (lsp-mode))

(use-package flycheck
  :hook (prog-mode)
  :config
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

(use-package cc-mode
  :ensure nil
  :hook ((c++-mode . my-c++-mode-hook)
         (c-mode . my-c-mode-hook))
  :config
  (defun my-c++-mode-hook()
    (setq c-basic-offset 4)
    (c-set-offset 'innamespace [0]))
  (defun my-c-mode-hook()
    (setq c-basic-offset 4)))

(use-package haskell-mode
  :hook (haskell-mode . my-haskell-mode-hook)
  :config
  (defun my-haskell-mode-hook()
    (haskell-indentation-mode -1)))

(use-package company
  :hook (prog-mode ledger-mode)
  :config
  (setq company-backends
        '((company-files
           company-capf
           company-yasnippet
           company-dabbrev
           ))
        )
  (setq company-dabbrev-downcase nil)
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 1)
  (setq company-tooltip-align-annotations t))

(use-package company-prescient
  :after (prescient company)
  :config (company-prescient-mode 1))

(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))
