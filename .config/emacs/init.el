;; -*- lexical-binding: t; -*-
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#21252B" "#E06C75" "#98C379" "#E5C07B" "#61AFEF" "#C678DD" "#56B6C2" "#ABB2BF"])
 '(blink-cursor-mode nil)
 '(custom-safe-themes
   '("651ecad7829ef7389b605bf6f1045a46c615b2edcbf2a2c18ad0565b8e1e588c" "c287bd7a3fd8fb587fd237324e208df449e440605dd43cdce9d0b0b9c0751256" "99ea831ca79a916f1bd789de366b639d09811501e8c092c85b2cb7d697777f93" "03b0bd6a3327bfc842a600a0e219c52e356cf26fd2a8dfeace1239a15f4ac978" "2b612b23bf48d4b80a282767055e1f132af3bbc135ca3d01e52be4621fa80b02" "669e02142a56f63861288cc585bee81643ded48a19e36bfdf02b66d745bcc626" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "08141ce5483bc173c3503d9e3517fca2fb3229293c87dc05d49c4f3f5625e1df" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" default))
 '(electric-pair-mode t)
 '(fci-rule-color "#3E4451")
 '(font-latex-fontify-script nil)
 '(hl-todo-keyword-faces
   '(("TODO" . "#dc752f")
     ("NEXT" . "#dc752f")
     ("THEM" . "#2d9574")
     ("PROG" . "#3a81c3")
     ("OKAY" . "#3a81c3")
     ("DONT" . "#f2241f")
     ("FAIL" . "#f2241f")
     ("DONE" . "#42ae2c")
     ("NOTE" . "#b1951d")
     ("KLUDGE" . "#b1951d")
     ("HACK" . "#b1951d")
     ("TEMP" . "#b1951d")
     ("FIXME" . "#dc752f")
     ("XXX+" . "#dc752f")
     ("\\?\\?\\?+" . "#dc752f")))
 '(package-selected-packages
   '(key-chord csharp-mode shakespeare-mode doom-themes lsp-haskell yaml-mode tidal dockerfile-mode typescript-mode lua-mode lsp-ui ledger-mode htmlize cmake-mode rust-mode haskell-mode go-mode lsp-mode spacemacs-theme exec-path-from-shell counsel-projectile org-bullets evil-mc smex counsel swiper ivy company-auctex evil-snipe auctex-latexmk auctex flycheck yasnippet-snippets yasnippet evil-matchit evil-nerd-commenter evil-surround projectile company evil magit use-package))
 '(pdf-view-midnight-colors '("#b2b2b2" . "#292b2e"))
 '(tetris-x-colors
   [[229 192 123]
    [97 175 239]
    [209 154 102]
    [224 108 117]
    [152 195 121]
    [198 120 221]
    [86 182 194]]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Monaco" :foundry "unknown" :slant normal :weight normal :height 128 :width normal))))
 '(font-latex-bold-face ((t (:foreground "#98C379" :weight bold))))
 '(font-latex-sectioning-2-face ((t (:inherit bold :foreground "#4f97d7" :height 1.0))))
 '(font-latex-slide-title-face ((t (:inherit (variable-pitch font-lock-type-face) :family "Monaco"))))
 '(font-latex-subscript-face ((t nil)))
 '(font-latex-superscript-face ((t nil))))

;; (setq gc-cons-threshold 50000000)
;; (setq large-file-warning-threshold 50000000)
(setq gc-cons-threshold most-positive-fixnum ; 2^61 bytes
      gc-cons-percentage 0.6)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 100000000
                  gc-cons-percentage 0.1)))

(setq read-process-output-max (* 1024 1024))

;; appearence
(setq inhibit-startup-screen t)
(setq frame-title-format '("%b"))
(set-frame-font "SourceCodePro 14" nil t)

(fset 'yes-or-no-p 'y-or-n-p)

(let ((file-name-handler-alist nil)) user-init-file)

;; enable copy and pasting
(setq select-enable-clipboard t)
(setq select-enable-primary t)

;; tabs
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

(setq scroll-step 1)
(setq scroll-margin 10)
(setq scroll-conservatively 999)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; (setq font-latex-fontify-sectioning 'color)
;; (setq font-latex-script-display (quote (nil)))
;; (setq font-latex-deactivated-keyword-classes
;;       '("italic-command" "bold-command" "italic-declaration" "bold-declaration"))

;; global key bindings
(global-set-key [f5] (lambda() (interactive) (revert-buffer t t)))
(global-set-key [f6] (lambda() (interactive) (find-file user-init-file)))
(global-set-key [remap list-buffers] 'buffer-menu-other-window)

;; load-path
(add-to-list 'load-path (expand-file-name "lisp/" user-emacs-directory))
(add-to-list 'custom-theme-load-path (expand-file-name "themes/" user-emacs-directory))

(load-theme 'darkplus)

(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))

(eval-when-compile
  (require 'use-package))

(use-package dired
  :ensure nil
  :hook (dired-mode . dired-hide-details-mode)
  :bind ("C-c d" . dired-jump)
  (:map dired-mode-map ("C-j" . dired-find-file))
  :config
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies 'always))

(use-package exec-path-from-shell
  :config
  (setq exec-path-from-shell-arguments nil)
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package magit
  :defer t
  :bind ("C-x g" . magit-status))

(use-package swiper
  :defer t
  :bind ("C-s" . swiper))

(use-package ivy
  :config
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-display-style 'fancy)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-extra-directories nil)
  (ivy-mode 1))

(use-package counsel
  :after ivy
  :bind
  ("M-x" . counsel-M-x)
  ("C-x C-f" . counsel-find-file)
  ("C-x b" . counsel-ibuffer)
  ("C-x d" . counsel-dired)
  ("C-c b" . bookmark-jump)
  ("C-c g" . counsel-rg)
  ("C-c i" . counsel-imenu)
  ("C-c r" . counsel-recentf)
  ("C-c z" . counsel-fzf))

(use-package projectile
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-enable-caching t)
  (setq projectile-completion-system 'ivy)
  (projectile-mode 1))

(use-package counsel-projectile
  :config
  (counsel-projectile-mode 1))

(use-package evil
  :config
  (defun evil-insert-new-line-normal-mode ()
    (interactive)
    (evil-open-below 1)
    (evil-normal-state)
    (message "")
    )
  (evil-mode 1)
  (evil-set-initial-state 'dired-mode 'emacs)
  (evil-set-initial-state 'ledger-report-mode 'emacs)
  (evil-set-initial-state 'flycheck-error-list-mode 'emacs)
  (setq evil-vsplit-window-right t)
  (setq evil-mode-line-format 'nil)
  (with-eval-after-load 'evil-maps
    (define-key evil-motion-state-map [down-mouse-1] nil))
  (evil-define-key 'normal 'lsp-mode-map (kbd "gd") 'lsp-find-definition)
  :bind (:map evil-normal-state-map
              ("gc" . evilnc-comment-or-uncomment-lines)
              ("gel" . flycheck-list-errors)
              ("gen" . flycheck-next-error)
              ("gep" . flycheck-previous-error)
              ("gz" . counsel-fzf)
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
  (evil-snipe-mode +1)
  (evil-snipe-override-mode +1))

(use-package evil-matchit
  :config (global-evil-matchit-mode 1))

(use-package key-chord
  :config
  (key-chord-mode 1)
  (setq key-chord-two-keys-delay 0.5)
  (key-chord-define evil-insert-state-map "hh" 'evil-normal-state))

(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :config (yas-reload-all))

(use-package evil-mc
  :config (global-evil-mc-mode 1))

(use-package org
  :defer t
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

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

(use-package tex
  :defer t
  :hook ((LaTeX-mode . company-mode)
         (LaTeX-mode . yas-minor-mode)
         (LaTeX-mode . visual-line-mode)
         (LaTeX-mode . LaTeX-math-mode))
  :ensure auctex
  :config
  (add-to-list 'TeX-view-program-list '("zathura" "/usr/bin/zathura %o"))
  (setcdr (assq 'output-pdf TeX-view-program-selection) '("zathura")))

(use-package lsp-mode
  :hook ((c++-mode . lsp)
         (go-mode . lsp)
         (haskell-mode . lsp)
         ;; (python-mode . lsp)
         (rust-mode . lsp)
         (typescript-mode . lsp))
  :commands lsp
  :init (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-response-timeout 25)
  (setq lsp-file-watch-threshold nil))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-peek-enable nil)
  (setq lsp-ui-imenu-enable nil)
  (setq lsp-ui-sideline-enable nil))

(use-package flycheck
  :hook ((prog-mode . flycheck-mode)
         (python-mode . my-flycheck-python-mode-hook))
  :config
  ;; (setq flycheck-check-syntax-automatically '(mode-enabled save))
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
  (defun my-flycheck-python-mode-hook()
    (setq flycheck-python-flake8-executable "/usr/bin/flake8")
    (setq flycheck-flake8rc "~/.config/flake8")))

(use-package cc-mode
  :defer t
  :hook ((c++-mode . my-c++-mode-hook)
         (c-mode . my-c-mode-hook))
  :config
  (defun my-c++-mode-hook()
    (setq c-basic-offset 4)
    (c-set-offset 'innamespace [0]))
  (defun my-c-mode-hook()
    (setq c-basic-offset 4)))

(use-package go-mode
  :defer t
  :hook (before-save . gofmt-before-save))

(use-package haskell-mode
  :defer t
  :config
  (defun haskell-evil-open-above ()
    (interactive)
    (evil-digit-argument-or-evil-beginning-of-line)
    (haskell-indentation-newline-and-indent)
    (evil-previous-line)
    (haskell-indentation-indent-line)
    (evil-append-line nil))

  (defun haskell-evil-open-below ()
    (interactive)
    (evil-append-line nil)
    (haskell-indentation-newline-and-indent))

  (evil-define-key 'normal haskell-mode-map
    "o" 'haskell-evil-open-below
    "O" 'haskell-evil-open-above))

(use-package ledger-mode
  :defer t
  :hook (ledger-mode . company-mode))

(use-package company
  :hook (prog-mode . company-mode)
  :config
  (setq company-backends
        '((company-files
           company-keywords
           company-capf
           company-yasnippet
           )
          (company-abbrev company-dabbrev)
          ))
  (setq company-dabbrev-downcase nil)
  (setq company-idle-delay 0.1)
  (setq company-tooltip-align-annotations t))

(use-package tidal
  :defer t
  :config (setq tidal-boot-script-path "/usr/share/x86_64-linux-ghc-8.10.1/tidal-1.6.1/BootTidal.hs"))
