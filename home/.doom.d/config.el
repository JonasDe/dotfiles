;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Allows jupyter notebook to display inline images
(setq ein:output-area-inlined-images t)

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/dotfiles/TODO")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Custom org-capture templates
(after! org
  (add-to-list 'org-capture-templates
               '("f" "File reference" entry
                 (file+headline +org-capture-todo-file "FileReference")
                 "* TODO %?\n :PROPERTIES:\n :CATEGORY: dream\n :END:\n %i\nfile:%F::%(with-current-buffer (org-capture-get :original-buffer) (number-to-string (line-number-at-pos)))"
                 :prepend t ))

  (add-to-list 'org-capture-templates
               '("x" "File reference" entry
                 (file+headline "~/dotfiles/TODO/cheatsheet.org" "Cheatsheet")
                 "* TODO %?\n :PROPERTIES:\n :CATEGORY: dream\n :END:\n %i\nfile:%F::%(with-current-buffer (org-capture-get :original-buffer) (number-to-string (line-number-at-pos)))"
                 :prepend t )))

  ;; (add-to-list 'org-capture-templates
  ;;              '("x" "CheatSheet" entry
  ;;                (file+headline "~/dotfiles/TODO/cheatsheet.org" "Cheatsheet")
  ;;                (file "~/.doom.d/templates/cheatsheet.org")
  ;;                :prepend t )))



;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;;

(define-key evil-visual-state-map (kbd "L") 'evil-end-of-line)
(define-key  evil-normal-state-map (kbd "L") 'evil-end-of-line)
(define-key evil-visual-state-map (kbd "H") 'evil-beginning-of-line)
(define-key  evil-normal-state-map (kbd "H") 'evil-beginning-of-line)
(define-key evil-normal-state-map (kbd "C-h") #'evil-window-left)
(define-key evil-normal-state-map (kbd "C-j") #'evil-window-down)
(define-key evil-normal-state-map (kbd "C-k") #'evil-window-up)
(define-key evil-normal-state-map (kbd "C-l") #'evil-window-right)
;; To make window navigation work in treemacs
(evil-define-key 'treemacs treemacs-mode-map (kbd "C-l") #'evil-window-right)


;; MACOS screenshot
(use-package org-download
  :after org
  :defer nil
  :custom
  (org-download-method 'directory)
  (org-download-image-dir "~/dotfiles/TODO/images")
  (org-download-heading-lvl nil)
  (org-download-timestamp "%Y%m%d-%H%M%S_")
  (org-image-actual-width 300)
  (org-download-screenshot-method "/usr/local/bin/pngpaste %s")
  :bind
  ("C-M-y" . org-download-screenshot)
  :config
  (require 'org-download))

(require 'evil-multiedit)
(evil-multiedit-default-keybinds)
