;; Performance tweaks for modern machines
(setq gc-cons-threshold 100000000) ; 100 mb
(setq read-process-output-max (* 1024 1024 4)) ; 4mb

;; Stop annoying warnings
(setq native-comp-async-report-warnings-errors nil)

;; Package management
(setopt use-package-always-ensure t)

(with-eval-after-load 'package
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

;; Emoji: 😄, 🤦, 🏴, ,  ;; should render as 3 color emojis and 2 glyphs
(defun trqt/set-fonts ()
  "Set the emoji and glyph fonts."
  (when (display-graphic-p)
    (set-fontset-font t 'symbol "Noto Color Emoji" nil 'prepend)
    ;; Set the font. Note: height = px * 100
    (set-face-attribute 'default nil :font "FantasqueSansM Nerd Font" :height 130)
    (set-face-attribute 'fixed-pitch nil :font "FantasqueSansM Nerd Font" :height 130)

    ;; variable pitch font
    (set-face-attribute 'variable-pitch nil :font "Libertinus Sans" :height 140 :weight 'normal)))

;; Emacs settings
(use-package emacs
  :ensure nil
  :custom
  (inhibit-startup-message t) ;; disables startup message
  (initial-scratch-message "")  ;; remove *scratch* message
  (display-line-numbers-type 'relative) ;; use relative line numbering
  (pixel-scroll-precision-mode t) ;; nicer scrolling
  (window-resize-pixelwise t) ;;  resize by pixels
  (frame-resize-pixelwise t) ;; resize by pixels
  (load-prefer-newer t) 
  (tab-always-indent 'complete) ;; indent or auto complete
  (indent-tabs-mode nil) ;; use spaces
  (backup-by-copying t) ;; copy files, don't link
  (custom-file (expand-file-name "custom.el" user-emacs-directory)) ;; put auto-generated lisp in a separated file


  :config
  ;; yes/no to y/n
  (defalias 'yes-or-no-p 'y-or-n-p)

  ;; Treesitter config
  (setq major-mode-remap-alist
        '((yaml-mode . yaml-ts-mode)
          (bash-mode . bash-ts-mode)
          (js-mode . js-ts-mode)
	  (js-jsx-mode . tsx-ts-mode)
	  (js-jsx-mode . tsx-ts-mode)
          (typescript-mode . typescript-ts-mode)
          (json-mode . json-ts-mode)
          (css-mode . css-ts-mode)
          (html-mode . html-ts-mode)
          (c-mode . c-ts-mode)
          (c++-mode . c++-ts-mode)
          (python-mode . python-ts-mode)))

  :hook
  (prog-mode . display-line-numbers-mode) ;; enable line numbers in programming modes

  :init

  (menu-bar-mode -1) ;; make it clean, remove the menu bar
  (tool-bar-mode -1) ;; make it clean, remove the tool bar
  (when scroll-bar-mode
    (scroll-bar-mode -1)) ;; hide the scroll bar

  (add-to-list 'default-frame-alist '(alpha-background . 90)) ;; make background transparent

  ;; set fonts
  (add-hook 'after-init-hook 'trqt/set-fonts)
  (add-hook 'server-after-make-frame-hook 'trqt/set-fonts)

  (indent-tabs-mode -1) ;; prefer spaces to tabs
  (savehist-mode t) ;; saves command history
  (save-place-mode t) ;; saves your place in files
  (recentf-mode t) ;; remember recent files
  (global-auto-revert-mode t) ;; auto reloads file when changed by external programs
  (xterm-mouse-mode 1) ;; enable mouse in terminal

  ;; lispy
  (electric-pair-mode t) ;; auto insert closing parenthesis
  (show-paren-mode t)) ;; auto-highlight matching parenthesis
  

;; Add unique buffer names in the minibuffer where there are many
;; identical files. This is super useful if you rely on folders for
;; organization and have lots of files with the same name,
;; e.g. foo/index.ts and bar/index.ts.
;; (require 'uniquify)

;; (setq uniquify-buffer-name-style 'forward)

(use-package uniquify
  :ensure nil
  :custom
  (uniquify-buffer-name-style 'forward))

;; No rubbish in my home!
(use-package no-littering
  :config
  (no-littering-theme-backups)
  :init
  (setq no-littering-etc-directory "~/.cache/emacs/etc/"
        no-littering-var-directory "~/.cache/emacs/var/"))

;; A package with a great selection of themes
(use-package ef-themes
  :custom
  (ef-themes-to-toggle '(ef-autumn ef-eagle))
  (ef-themes-mixed-font t)
  :config
  (ef-themes-select 'ef-eagle))


;; Transparency

;; Die DocView
(defalias 'doc-view-mode #'doc-view-fallback-mode) ;Or fundamental-mode, ...

;; Make the windows more visible
(use-package golden-ratio
  :custom
  (golden-ratio-auto-scale t)
  :hook
  (after-init . golden-ratio-mode))

;; Minibuffer completion is essential to your Emacs workflow and
;; Vertico is currently one of the best out there. There's a lot to
;; dive in here so I recommend checking out the documentation for more
;; details: https://elpa.gnu.org/packages/vertico.html. The short and
;; sweet of it is that you search for commands with "M-x do-thing" and
;; the minibuffer will show you a filterable list of matches.
(use-package vertico
  :custom
  (vertico-cycle t)
  (read-buffer-completion-ignore-case t)
  (read-file-name-completion-ignore-case t)
  (completion-styles '(basic substring partial-completion flex))
  :hook
  (after-init . vertico-mode))

;; Improve the accessibility of Emacs documentation by placing
;; descriptions directly in your minibuffer. Give it a try:
;; "M-x find-file".
(use-package marginalia
  :after vertico
  :init
  (marginalia-mode))

;; Completion package
(use-package corfu
  :defer t
  :custom
  ;;(corfu-auto t)
  (corfu-quit-no-match 'separator)

  ;; You may want to play with delay/prefix/styles to suit your preferences.
  ;; (corfu-auto-delay 0)
  ;; (corfu-auto-prefix 0)
  ;;(completion-styles '(basic))
  :hook
  (after-init . global-corfu-mode))

(use-package cape
  :defer t
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-emoji)
  (add-to-list 'completion-at-point-functions #'cape-tex))

(use-package corfu-popupinfo
  :after corfu
  :ensure nil
  :hook (corfu-mode . corfu-popupinfo-mode)
  :custom
  (corfu-popupinfo-delay '(0.25 . 0.1))
  (corfu-popupinfo-hide nil)
  :config
  (corfu-popupinfo-mode))

;; Make completion searching sound
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Consult: Misc. enhanced commands
(use-package consult
  :bind (
         ;; Drop-in replacements
         ("C-x b" . consult-buffer)     ; orig. switch-to-buffer
         ("M-y"   . consult-yank-pop)   ; orig. yank-pop
         ;; Searching
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)     ; Alternative: rebind C-s to use
         ("M-s s" . consult-line) ; consult-line instead of isearch, bind
         ("M-s L" . consult-line-multi) ; isearch to M-s s
         ("M-s o" . consult-outline)
         ;; Isearch integration
         :map isearch-mode-map
         ("M-e" . consult-isearch-history) ; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history) ; orig. isearch-edit-string
         ("M-s l" . consult-line) ; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi) ; needed by consult-line to detect isearch
         )
  :custom
  ;; Narrowing lets you restrict results to certain groups of candidates
  (consult-narrow-key "<"))

;; Contextual actions
(use-package embark
  :demand t
  :after avy
  :bind (("C-c a" . embark-act))
  :init
  ;; Add the option to run embark when using avy
  (defun trqt/avy-action-embark (pt)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (embark-act))
      (select-window
       (cdr (ring-ref avy-ring 0))))
    t)

  ;; After invoking avy-goto-char-timer, hit "." to run embark at the next
  ;; candidate you select
  (setf (alist-get ?. avy-dispatch-alist) 'trqt/avy-action-embark))

(use-package embark-consult
  :ensure t)

;; LSP package
(use-package eglot
  :defer t
  :bind (("s-<mouse-1>" . eglot-find-implementation)
         ("C-c ." . eglot-code-action-quickfix)
         ("C-c ;" . eglot-code-actions))
  :hook ((go-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (haskell-mode . eglot-ensure)
         ;;(clojure-mode . eglot-ensure)
         (python-ts-mode . eglot-ensure)
         (js-ts-mode . eglot-ensure)
         (typescript-ts-mode . eglot-ensure)
         (tsx-ts-mode . eglot-ensure)
         (java-mode . eglot-ensure)
         (c-ts-mode . eglot-ensure)
         (c++-ts-mode . eglot-ensure))
  :custom
  (eglot-autoshutdown t)
  (eglot-confirm-server-initiated-edits nil) ;; DWIM, don't ask to change
  (eglot-ignored-server-capabilities '(:documentOnTypeFormattingProvider))
  (eglot-events-buffer-config '(:size 20000 :format short))
  :config
  (fset #'jsonrpc--log-event #'ignore))
  ;; Perfomance boost(?)


  ;; Perfomance Boost!
  ;; (use-package eglot-booster
  ;;   :ensure nil
  ;;   :after eglot
  ;;   :vc (:fetcher github :repo "jdtsmith/eglot-booster")
  ;;   :config (eglot-booster-mode))

  ;; Add extra context to Emacs documentation to help make it easier to
  ;; search and understand. This configuration uses the keybindings 
  ;; recommended by the package author.
  (use-package helpful
    :bind (("C-h f" . #'helpful-callable)
           ("C-h v" . #'helpful-variable)
           ("C-h k" . #'helpful-key)
           ("C-c C-d" . #'helpful-at-point)
           ("C-h F" . #'helpful-function)
           ("C-h C" . #'helpful-command)))

;; loads correct enviroment
(use-package envrc
  :hook (after-init . envrc-global-mode))

;; Which key, make the commands more accessible
(use-package which-key
  :defer t
  :hook
  (after-init . which-key-mode)
  :config
  (setq which-key-side-window-location 'bottom
	which-key-sort-order #'which-key-key-order-alpha
	which-key-sort-uppercase-first nil
	which-key-add-column-padding 1
	which-key-max-display-columns nil
	which-key-min-display-lines 6
	which-key-side-window-slot -10
	which-key-side-window-max-height 0.25
	which-key-idle-delay 0.8
	which-key-max-description-length 25
	which-key-allow-imprecise-window-fit t
	which-key-separator " → " ))

;; Better undo(change it to undo-fu, vundo and undo-fu-session ?)
;; (use-package undo-tree
;;   :defer t
;;   :custom
;;   (undo-tree-auto-save-history nil)

;;   :hook
;;   (after-init . global-undo-tree-mode))

(use-package undo-fu-session
  :defer t
  :custom
  (undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'")
                                      :hook (after-init . undo-fu-session-global-mode)))

(use-package vundo
  :defer t
  :bind (("C-x u" . vundo)))

;; VI VI VI
(use-package evil
  :demand t
  :custom
  (evil-want-integration t)
  (evil-want-keybinding nil)
  (evil-want-C-u-scroll t)
  (evil-undo-system 'undo-redo)
  :init
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

;; Blazing fast navigation
(use-package avy
  :demand t
  :bind (("C-c j" . avy-goto-char-timer)))


;; org-mode
(use-package org
  :ensure nil
  :defer t
  :custom
  (org-startup-indented t)
  (org-pretty-entities t)
  (org-hide-emphasis-markers t)
  (org-startup-with-inline-images t)
  (org-image-actual-width '(300))
  (org-agenda-files '("~/docs/todo.org")))

(use-package org-appear
  :defer t
  :hook
  (org-mode . org-appear-mode))

(use-package org-modern
  :defer t
  :hook
  (org-mode . global-org-modern-mode)
  (org-mode . visual-line-mode)
  (org-mode . variable-pitch-mode))

(use-package org-faces
  :ensure nil
  :config
  ;; Increase the size of various headings
  (set-face-attribute 'org-document-title nil :font "Libertinus Serif" :weight 'medium :height 1.3)
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Libertinus Serif" :weight 'medium :height (cdr face))))

;; center text
(use-package olivetti
  :defer t) 

;; Spell checking
(use-package jinx
  :defer t
  :custom
  (jinx-languages "en_GB pt_BR")
  :bind (("C-c DEL" . jinx-correct)
         ("M-$" . jinx-languages)))

;; Why obsidian when we have public, free and of quality software
(use-package denote
  :defer t
  :custom
  (denote-known-keywords '("emacs" "journal"))
  ;; This is the directory where your notes live.
  (denote-directory (expand-file-name "~/docs/denote/"))
  (denote-templates '((review . "Author: \n\n* Resumo\n\n* Interpretação")))
  :config
  (require 'ox-md)
  (denote-rename-buffer-mode)
  :bind
  (("C-c n n" . denote)
   ("C-c n f" . denote-open-or-create)
   ("C-c n t" . denote-template)
   ("C-c n m" . denote-type)
   ("C-c n i" . denote-link-or-create))
   ("C-c n b" . denote-backlinks)
   ("C-c n r" . denote-rename-file)
   ("C-c n R" . denote-rename-file-using-front-matter))

(use-package denote-journal
  :after denote
  :hook (calendar-mode . denote-journal-calendar-mode)
  :config
  (setq denote-journal-directory (expand-file-name "journal" denote-directory))
  (setq denote-journal-keyword "journal")
  (setq denote-journal-title-format 'day-date-month-year))

(use-package denote-org
  :after denote)

;; Oh! Ma Git
(use-package magit
  :defer t
  :bind (("C-c g" . magit-status)))

;; Make focused windows more obvious
(use-package breadcrumb
  :hook
  (after-init . breadcrumb-mode))

;; http://danmidwood.com/content/2014/11/21/animated-paredit.html
;; https://stackoverflow.com/a/5243421/3606440
(use-package paredit
  :defer t
  :hook ((emacs-lisp-mode . enable-paredit-mode)
         (lisp-mode . enable-paredit-mode)
         (ielm-mode . enable-paredit-mode)
         (lisp-interaction-mode . enable-paredit-mode)
         (scheme-mode . enable-paredit-mode)))

(use-package go-mode
  :defer t
  :bind (:map go-mode-map
	      ("C-c C-f" . 'gofmt))
  :hook (before-save . gofmt-before-save))

(use-package markdown-mode
  :defer t
  :hook (markdown-mode . visual-line-mode)
  :init
  (setq markdown-command "pandoc --mathml"))

;; C 
(use-package c-ts-mode
  :ensure nil
  :custom
  (c-default-style "bsd")
  (c-basic-offset 4)
  (c-ts-mode-indent-style 'bsd)
  (c-ts-mode-indent-offset 4)
  :bind (:map c-ts-mode-map
              ("C-c C-c" . compile)
              ("C-c C-f" . eglot-format)))

;; Ruff for python
(use-package flymake-ruff
  :hook (eglot-managed-mode . flymake-ruff-load))

(use-package rust-mode
  :defer t
  :custom
  (rust-mode-treesitter-derive t)
  :bind (:map rust-mode-map
	      ("C-c C-r" . 'rust-run)
	      ("C-c C-c" . 'rust-compile)
	      ("C-c C-f" . 'rust-format-buffer)
	      ("C-c C-t" . 'rust-test))
  :hook (rust-mode . prettify-symbols-mode))

(use-package haskell-mode
  :defer t
  :hook (haskell-mode . prettify-symbols-mode)
  :bind (:map haskell-mode-map
              ("C-c C-c" . haskell-compile)))

;; Clojure
(use-package clojure-mode
  :defer t)

(use-package cider
  :defer t)

;; Coq support
(defun trqt/disable-corfu ()
  "Disable corfu(for company-coq)"
  (corfu-mode -1))

(use-package proof-general
  :defer t)

(use-package company-coq
  :defer t
  :hook ((coq-mode . company-coq-mode)
         (coq-mode . trqt/disable-corfu)))

;; OCaml
(use-package tuareg
  :defer t
  :mode (("\\.ocamlinit\\'" . tuareg-mode)))

;; Matrix support
;; (use-package ement
;;   :vc (:fetcher github :repo "alphapapa/ement.el"))

;; ;; RSS support
(use-package elfeed
  :defer t
  :custom
  (elfeed-db-directory
   (expand-file-name "elfeed" user-emacs-directory))
  :bind (("C-c w" . 'elfeed)))

(use-package elfeed-org
  :after elfeed
  :config
  (elfeed-org)
  :custom
  (rmh-elfeed-org-files
   (list (concat (file-name-as-directory
              (getenv "HOME"))
                 "docs/elfeed.org"))))

;; IRC

;; Telegram
(setq org-file-apps
      '((auto-mode . emacs)
        (directory . emacs)
        ("\\.pdf\\'" . "xdg-open %s")
        ("\\.epub\\'" . "xdg-open %s")
        ("\\.djvu\\'" . "xdg-open %s")
        (t . "xdg-open %s"))) ;; xdg-open to open files

(use-package tracking
  :defer t)
(use-package telega
  :defer t
  :ensure nil
  :config
  (setq telega-use-tracking-for '(or unmuted mention)
        telega-completing-read-function #'completing-read
        telega-msg-rainbow-title t
        telega-chat-fill-column 75
        telega-server-libs-prefix "~/.nix-profile"
        telega-use-images t
        telega-open-file-function 'org-open-file
        telega-chat-show-deleted-messages-for '(not saved-messages)))

(use-package typst-ts-mode
  :vc (:url "https://codeberg.org/meow_king/typst-ts-mode"))

;; ;; LaTeX and Scientific Writing
;; (defun trqt/latex-electric-math ()
;;   (set (make-local-variable 'TeX-electric-math)
;;        (cons "\\(" "\\)")))

;; ;; THE LaTeX mode
;; (use-package auctex
;;   :hook
;;   ((LaTeX-mode . prettify-symbols-mode)
;;    (LaTeX-mode . trqt/latex-electric-math))
;;   :custom 
;;   (reftex-plug-into-AUCTeX t)
;;   (TeX-auto-save t)
;;   (TeX-fold-mode t)
;;   (TeX-parse-self t)
;;   ;;(setq-default TeX-master nil)         ; ask for master file
;;  )

;; ;; useful latex abbreviations with `
;; (use-package cdlatex
;;   :custom
;;   (cdlatex-takeover-dollar nil)
;;   :hook
;;   (LaTeX-mode . turn-on-cdlatex)
;;   (org-mode . turn-on-org-cdlatex))
;; (use-package evil-tex
;;   :after evil
;;   :hook
;;   (LaTeX-mode . evil-tex-mode))

;; Make it trivial to cite papers
(use-package citar
  :defer t
  :custom
  (org-cite-global-bibliography '("~/docs/references.bib"))

  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar)

  (citar-bibliography org-cite-global-bibliography)
  :hook
  (LaTeX-mode . citar-capf-setup)
  (org-mode . citar-capf-setup)
  :bind (:map org-mode-map
              :package org ("C-c b" . org-cite-insert)))

(use-package citar-embark
  :after citar embark
  :no-require
  :init
  (citar-embark-mode))

(use-package ledger-mode
  :defer t
  :mode ("\\.dat\\'"
         "\\.ledger\\'"))
