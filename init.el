;;; abeato's emacs configuration file
;;; Installed packages:
; ace-window ag async auto-complete avy bm dash diff-hl epl f flx flx-ido
; go-mode helm helm-core helm-projectile smart-tabs-mode
; pkg-info popup projectile projectile-speedbar s sr-speedbar
; color-theme color-theme-solarized dtrt-indent ggtags
;;;
;; Install in the system:
;; ag (silver searcher) gtags godef
;; (see http://tleyden.github.io/blog/2014/05/22/configure-emacs-as-a-go-editor-from-scratch/
;; for godef)
;;;
;; To avoid the invisible scroll bar issue:
;; Add ppa http://www.noobslab.com/p/themes-icons.html -> not needed since 17.04
;; sudo apt-get install arc-theme
;; GTK_THEME=Arc-Dark emacs
;; Other themes that can help: ZorinBlue-Dark, Emacs
;;;
;; Modify /usr/share/applications/emacs25.desktop:
;; Exec=env GTK_THEME=Arc-Dark /usr/bin/emacs25 %F
;; You need to execute manually (load-theme 'solarized t) once
;;;
;; Create aliases (new frame, current frame):
;; alias ec='emacsclient -nc'
;; alias emacs='emacsclient -n'
;;;
;; Remove annoying unity shorcuts:
;; From CompizConfig, unity plugin, remove "Alt" as key to show HUD
;;;
;; Using rtags: https://github.com/Andersbakken/rtags/wiki/Usage
;;   and https://raw.githubusercontent.com/philippe-grenet/exordium/master/modules/init-rtags.el
;; Download deb source package from disco, adapt and create the debs.
;; apt install rtags_2.21-3_amd64.deb elpa-rtags_2.21-3_all.deb
;; systemctl start --user rdm
;; # To generate compile_commands.json:
;; cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
;; # Generate database:
;; rtags-rc -J
;; Then you can start using rtags command
;;
;;;
;; elisp tutorials
;;   http://steve-yegge.blogspot.com/2008/01/emergency-elisp.html
;;   https://www.reddit.com/r/emacs/comments/3aslwu/what_are_the_best_resources_for_learning_elisp/
;; Run linter:
;;   /usr/bin/emacs -Q --batch -l ~/.emacs.d/elpa/elisp-lint-20200102.1550/elisp-lint.el -f elisp-lint-files-batch roman-numerals.el
;;;
;; eshell tricks
;;    write beginning, then UP for searching history:
;;    https://stackoverflow.com/questions/13009908/eshell-search-history
;;    use buit-ins like 'cd' or 'cp' with TRAMP 'address' like;
;;    cd /ssh:admin@192.168.1.56:

(setq mouse-wheel-scroll-amount '(3 ((shift) . 2) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)
(setq scroll-step            1
      scroll-conservatively  10000)
(setq auto-window-vscroll nil)
(column-number-mode)
; Remove selection when we write
(delete-selection-mode)
; Do nothing if region inactive for commands that use the mark
(setq mark-even-if-inactive nil)
; Default size for frames
(setq default-frame-alist '((width . 120) (height . 40)))

; Start server. Complemented with
; alias emacs='GTK_THEME=Arc-Dark emacsclient -n'
(server-start)

; Remove tool bar
(tool-bar-mode -1)
; Preserve position of point in display when scrolling
;(setq scroll-preserve-screen-position t)

;(require 'color-theme)
;(color-theme-initialize)
;(color-theme-clarity)
;(color-theme-clarity)

(global-set-key (kbd "C-,") 'previous-buffer)
(global-set-key (kbd "C-.") 'next-buffer)
(global-set-key (kbd "C-d") 'delete-backward-char)
;; It is not possible to use C-i due to the links it has with TAB
;; (auto-completion is C-i and some times TAB is that too). So if
;; this is enabled you end up deleting words when pressing TAB.
;(global-set-key (kbd "C-i") 'backward-kill-word)
;(global-set-key (kbd "C-2") 'kill-region)
(global-set-key (kbd "C-ñ") 'backward-kill-word)

;;; Visual studio style bookmarks (bm.el)
(global-set-key (kbd "<C-f2>") 'bm-toggle)
(global-set-key (kbd "<f2>")   'bm-next)
(global-set-key (kbd "<S-f2>") 'bm-previous)
;(setq bm-highlight-style 'bm-highlight-only-fringe)

(global-set-key (kbd "C-x g") 'magit-status)

(show-paren-mode 1)
; emacs 26: see https://emacs.stackexchange.com/questions/278/how-do-i-display-line-numbers-in-emacs-not-in-the-mode-line
;(global-linum-mode 1)
;(global-display-line-numbers-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;(require 'uniquify) ; bundled with GNU emacs 23.2.1 or before. On in 24.4
; Append directory name to the beginning for buffers with the same name
;(setq uniquify-buffer-name-style 'post-forward)

;;; Automatically reload files changed outside emacs.
;;; If the buffer was being changed inside emacs too, it is not reloaded.
(global-auto-revert-mode t)
; Set auto revert for all buffer types so buffer-menu is refreshed as needed.
; There is a bug that provokes re-centering when this is set. Supposed to be
; fix in 24.4. sr-speedbar affected too.
;(setq global-auto-revert-non-file-buffers t)

; Save files that have been opened
(desktop-save-mode 1)

; More space for file name column in ibuffer
(setq ibuffer-formats
'((mark modified read-only " " (name 25 25 :left :elide) " " (mode 10 10 :left :elide) " " filename-and-process) (mark " " (name 16 -1) " " filename)))

; Workaround to get tildes (see LP bug #1251176)
(require 'iso-transl)

;;; Emacs is not a package manager, and here we load its package manager!
(require 'package)
(dolist (source '(("marmalade" . "http://marmalade-repo.org/packages/")
                  ;;("elpa" . "http://tromey.com/elpa/") ; Not maintained?
                  ;; TODO: Maybe, use this after emacs24 is released
                  ;; (development versions of packages)
                  ("melpa" . "http://melpa.milkbox.net/packages/")
                  ))
(add-to-list 'package-archives source t))
(package-initialize)

;;; Apparently we can use dowloaded packages only after package-initialize

;(require 'ido-vertical-mode)
; Looks like flx-ido functionality is already in emacs distro
;(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
;(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
;(setq ido-use-faces nil)
;(ido-vertical-mode 1)

; CEDET
; Disable... too slow for our C++ :(
;(semantic-mode 1)
;(global-ede-mode 1)            ; Enable the Project management system

;; Semantic
; Disable... too slow for our C++ :(
;(global-semantic-idle-scheduler-mode)
; Not really necessary with auto-complete on, probably
;(global-semantic-idle-completions-mode)
; Show declaration at bottom
;(global-semantic-idle-summary-mode)
;(global-semantic-decoration-mode)
;(global-semantic-highlight-func-mode)
; Underline in red if text cannot be parsed: annoying
;(global-semantic-show-unmatched-syntax-mode)
; on by default:
;(global-semanticdb-minor-mode)
; Highlight all appareances of symbol near point
;(global-semantic-idle-local-symbol-highlight-mode)
; Go back to last edited tag
;(global-semantic-mru-bookmark-mode)

;(semanticdb-enable-gnu-global-databases 'c-mode)
;(semanticdb-enable-gnu-global-databases 'c++-mode)

; start rdm/rtags
(rtags-start-process-unless-running)
; Enbla RTAGS bindings
(rtags-enable-standard-keybindings)
; Enable completion with company + rtags
(require 'package)
(package-initialize)
(require 'rtags)
(require 'company)
(setq rtags-completions-enabled t)
(push 'company-rtags company-backends)
(global-company-mode)
(define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))

; cofigured dired-x
(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")
            ;; Set dired-x global variables here.  For example:
            ;; (setq dired-guess-shell-gnutar "gtar")
            ;; (setq dired-x-hands-off-my-keys nil)
            ))
(add-hook 'dired-mode-hook
          (lambda ()
            ;; Set dired-x buffer-local variables here.  For example:
            ;; (dired-omit-mode 1)
            ))

; Key to use semantic to jump to tag
;(global-set-key (kbd "<f5>") 'semantic-ia-fast-jump)
; Switch between prototype and implementation
;(global-set-key (kbd "<f6>") 'semantic-analyze-proto-impl-toggle)
(global-set-key (kbd "s-z") 'avy-goto-word-or-subword-1)
(global-set-key (kbd "s-<") 'ace-window)
(global-set-key (kbd "s-x") 'other-window)

(global-set-key (kbd "<f5>") 'rtags-print-symbol-info)
(global-set-key (kbd "<f6>") 'rtags-symbol-type)

;; (defun my-semantic-hook ()
;;   (imenu-add-to-menubar "TAGS"))
;; (add-hook 'semantic-init-hooks 'my-semantic-hook)

; This hook is needed to enforce the c-file-style local variable if defined in
; ede-cpp-root-project. See
;http://sourceforge.net/p/cedet/mailman/message/28529831/
;; (defmethod ede-set-project-variables :after ((this ede-cpp-root-project)
;;                                               &optional buffer)
;;   (when (and c-file-style (eq major-mode 'c-mode))
;;     (c-set-style c-file-style)))

; Specify project for semantic searches. Of the two options, ede is better
; because you can indicate folders to search for include files.
; You can specify include paths, macros defined when compiling, and project
; local variables.
; EDE also parses Makefile.am files automatically, but for some projects it
; works and for other it does not do it very well.
;(setq-default semanticdb-project-roots (list "/mnt/data/telephony/git_abeato/ofono"))
;; (ede-cpp-root-project "OFONO_GITHUB"
;; 		      :file "~/src/ofono/github/Makefile.am"
;; 		      :include-path '( "/include" "/src" "/gril" "/drivers/rilmodem" "/plugins" )
;; 		      :local-variables '((backward-delete-char-untabify-method . nil)
;; 					 (indent-tabs-mode . t)
;; 					 (c-syntactic-indentation . nil)
;; 					 (c-file-style . "linux"))
;; 		      )

;; (ede-cpp-root-project "OFONO_UPSTREAM"
;; 		      :file "~/src/ofono/upstream/Makefile.am"
;; 		      :include-path '( "/include" "/src" "/gril" "/drivers/rilmodem" "/plugins" )
;; 		      :local-variables '((backward-delete-char-untabify-method . nil)
;; 					 (indent-tabs-mode . t)
;; 					 (c-syntactic-indentation . nil)
;; 					 (c-file-style . "linux"))
;; 		      )

; C style for NM
(load "~/.emacs.d/networkmanager-style.el")

; Commands to force parsing of a tree (easier to use is lk-parse-curdir-c, from
; project root).
; Otherwise semantic parses only files that you opened previously.
;(load "~/.emacs.d/semantic-parse.el")

; Show full path in title
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; show unncessary whitespace that can mess up your diff
(add-hook 'prog-mode-hook (lambda () (interactive) (setq show-trailing-whitespace 1)))

;; CC-mode (view line numbers and add semantic source to auto-complete)
;(add-hook 'c-mode-common-hook '(lambda () (linum-mode 1)))
;(add-hook 'c-mode-common-hook '(lambda ()
;        (setq ac-sources (append '(ac-source-semantic) ac-sources))
;))
; Seems that adding system includes must be done via hooks
;(add-hook 'c-mode-common-hook '(lambda () (semantic-add-system-include "/usr/include/glib-2.0")))

; Avoid conversion of tabs to spaces when deleting
;(setq backward-delete-char-untabify-method nil)
;(setq c-default-style "linux") ; Use tabs (=8 spaces), always move in tab units
;(setq c-syntactic-indentation nil) ; Not enforce syntatic indentation (move freedom)
;(setq-default c-insert-tab-function 'tab-to-tab-stop)
(setq-default indent-tabs-mode nil) ; No tab codes
(setq c-default-style "stroustrup") ; 4-space stops
; Indent automatically when pressing RET (RET=C-j)
(define-key global-map (kbd "RET") 'newline-and-indent)

;;; ggtags
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              (ggtags-mode 1))))

;;; No tabs in shell mode
(add-hook 'sh-mode-hook (lambda () (setq indent-tabs-mode nil)))

;; eshell customizations (see custom-set-variables below):
;; customized eshell-prompt-regexp (so it works when # is part of the prompt,
;; which happens when using TRAMP and you ssh to a non-usual port (like
;; '/ssh:alfonsosanchezbeato@localhost#8022:/home/alfonsosanchezbeato $ ')
;; Example of ssh+sudo:
;; find-file '/ssh:alfonsosanchezbeato@localhost#8022|sudo:localhost#8022:/home/alfonsosanchezbeato/ccc'
;; after doing it once for one file, you do not need the ssh part anymore
;; See https://ipfs-sec.stackexchange.cloudflare-ipfs.com/emacs/A/question/5608.html
(require 'em-tramp) ; to load eshell’s sudo
;; Change some key bindings in eshell
(add-hook 'eshell-mode-hook (lambda ()
                              (local-set-key (kbd "<up>") 'previous-line)
                              (local-set-key (kbd "<down>") 'next-line)))
;; To avoid "WARNING: terminal is not fully functional" for some commands
(setenv "PAGER" "cat")

;;; Guess indentation
;;; NOTE this is known to have issues in some cases, for instance shell scripts
(require 'dtrt-indent)
(dtrt-indent-mode 1)
; Remove dtrt-indent messages in echo area
;(setq dtrt-indent-verbosity 0)

;;; golang settings
(setenv "GOPATH" "/home/abeato/go")
;(add-hook 'go-mode-hook '(lambda () (linum-mode 1)))
;(add-hook 'before-save-hook 'gofmt-before-save)
(defun my-go-mode-hook ()
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
  )
(add-hook 'go-mode-hook 'my-go-mode-hook)

;; python mode settings
;(add-hook 'python-mode-hook '(lambda () (linum-mode 1)))

;; shell mode settings
;(add-hook 'sh-mode-hook '(lambda () (linum-mode 1)))

;; Autocomplete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories (expand-file-name
             "~/.emacs.d/elpa/auto-complete-1.4.20110207/dict"))
(setq ac-comphist-file (expand-file-name
             "~/.emacs.d/ac-comphist.dat"))
(ac-config-default)

;(projectile-global-mode)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(setq sr-speedbar-right-side nil)

;(require 'helm-config)
; helm is annoying for grep/ag
;(require 'helm-projectile)
;(helm-projectile-on)

; slot > 0 -> to the right
(add-to-list 'display-buffer-alist
             `(,(rx (or "ag search" "ggtags-global"))
               (display-buffer-reuse-window
                display-buffer-in-side-window)
               (reusable-frames . visible)
               (side            . bottom)
               (slot            . 1)
               (window-height   . 0.4)))

(defun lunaryorn-quit-bottom-side-windows ()
  "Quit side windows of the current frame."
  (interactive)
  (dolist (window (window-at-side-list))
    (quit-window nil window)))

(global-set-key (kbd "C-c q") 'lunaryorn-quit-bottom-side-windows)

(defun enable-tabs () (interactive)
  (local-set-key (kbd "TAB") 'tab-to-tab-stop)
  (setq indent-tabs-mode t)
  (setq c-syntactic-indentation nil)
  (setq c-file-style "linux"))

(defun disable-tabs () (interactive) (setq indent-tabs-mode nil))

(require 'dired)
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)

(setq org-startup-truncated nil)
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key org-mode-map (kbd "C-,") nil)
(setq org-log-done "time")
(setq org-support-shift-select t)
(org-babel-do-load-languages 'org-babel-load-languages
    '(
        (shell . t)
    )
)

; Do not break long lines in term/ansi-term
(setq term-suppress-hard-newline t)
; max size for term/ansi-term buffer
(setq term-buffer-maximum-size 10000)

; To display ansi colors in buffer
(require 'ansi-color)
(defun display-ansi-colors ()
  (interactive)
  (ansi-color-apply-on-region (point-min) (point-max)))

; Automatically update default-directory by looking at the prompt
; https://snarfed.org/why_i_run_shells_inside_emacs
; the regex stores the path in regex group 1: the input is the prompt line.
; Example of how it works:
;(string-match "^.*[^ ]+:\\(.*\\)[$#]" "abeato@numancia:~/src/build-envs$ sdzzxvc zxcv")
;(match-string 1 "abeato@numancia:~/src/build-envs$ sdzzxvc zxcv")
(defun my-dirtrack-mode ()
  "Add to shell-mode-hook to use dirtrack mode in my shell buffers."
  (shell-dirtrack-mode 0)
  (set-variable 'dirtrack-list '("^.*[^ ]+:\\(.*\\)[$#]" 1 nil))
  (dirtrack-mode 1))
(add-hook 'shell-mode-hook 'my-dirtrack-mode)
; bash completion in shell: https://github.com/szermatt/emacs-bash-completion
(autoload 'bash-completion-dynamic-complete
  "~/.emacs.d/bash-completion.el"
  "BASH completion hook")
(add-hook 'shell-dynamic-complete-functions
          'bash-completion-dynamic-complete)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(comint-password-prompt-regexp
   "\\(^ *\\|\\( SMB\\|'s\\|Bad\\|CVS\\|Enter\\(?: \\(?:\\(?:sam\\|th\\)e\\)\\)?\\|Kerberos\\|LDAP\\|New\\|Old\\|Repeat\\|UNIX\\|\\[sudo]\\|enter\\(?: \\(?:\\(?:sam\\|th\\)e\\)\\)?\\|login\\|new\\|old\\) +\\)\\(?:\\(?:adgangskode\\|contrase\\(?:\\(?:ny\\|ñ\\)a\\)\\|geslo\\|h\\(?:\\(?:asł\\|esl\\)o\\)\\|iphasiwedi\\|jelszó\\|l\\(?:ozinka\\|ösenord\\)\\|m\\(?:ot de passe\\|ật khẩu\\)\\|pa\\(?:rola\\|s\\(?:ahitza\\|s\\(?: phrase\\|code\\|ord\\|phrase\\|wor[dt]\\)\\|vorto\\)\\)\\|s\\(?:alasana\\|enha\\|laptažodis\\)\\|wachtwoord\\|лозинка\\|пароль\\|ססמה\\|كلمة السر\\|गुप्तशब्द\\|शब्दकूट\\|গুপ্তশব্দ\\|পাসওয়ার্ড\\|ਪਾਸਵਰਡ\\|પાસવર્ડ\\|ପ୍ରବେଶ ସଙ୍କେତ\\|கடவுச்சொல்\\|సంకేతపదము\\|ಗುಪ್ತಪದ\\|അടയാളവാക്ക്\\|රහස්පදය\\|ពាក្យសម្ងាត់\\|パスワード\\|密[码碼]\\|암호\\)\\|Response\\)\\(?:\\(?:, try\\)? *again\\| (empty for no passphrase)\\| (again)\\)?\\(?: \\(for\\|para\\) [^:：៖]+\\)?[:：៖]\\s *\\'")
 '(custom-safe-themes
   (quote
    ("3d5307e5d6eb221ce17b0c952aa4cf65dbb3fa4a360e12a71e03aab78e0176c5" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "e4e97731f52a5237f37ceb2423cb327778c7d3af7dc831788473d4a76bcc9760" default)))
 '(ediff-split-window-function (quote split-window-horizontally))
 '(eshell-history-size 5000)
 '(eshell-prompt-regexp "^[^$
]* [#$] ")
 '(font-use-system-font t)
 '(frame-background-mode (quote dark))
 '(make-backup-files nil)
 '(package-selected-packages
   (quote
    (magit elisp-refs ac-rtags yaml-mode sr-speedbar smart-tabs-mode go-mode ggtags flx-ido dtrt-indent color-theme-solarized auto-complete ag ace-window)))
 '(safe-local-variable-values
   (quote
    ((eval c-set-offset
           (quote innamespace)
           0)
     (eval when
           (fboundp
            (quote c-toggle-comment-style))
           (c-toggle-comment-style 1))
     (eval c-set-offset
           (quote arglist-close)
           0)
     (eval c-set-offset
           (quote arglist-intro)
           (quote ++))
     (eval c-set-offset
           (quote case-label)
           0)
     (eval c-set-offset
           (quote statement-case-open)
           0)
     (eval c-set-offset
           (quote substatement-open)
           0))))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bm-face ((t (:background "DodgerBlue4"))))
 '(bm-fringe-face ((t (:background "gray51" :foreground "#002b36"))))
 '(ediff-current-diff-C ((t (:background "brown"))))
 '(ediff-even-diff-A ((t (:background "dark red" :foreground "dark gray"))))
 '(ediff-even-diff-Ancestor ((t (:background "dark olive green" :foreground "white smoke"))))
 '(ediff-even-diff-B ((t (:background "saddle brown" :foreground "dark gray"))))
 '(ediff-fine-diff-Ancestor ((t (:background "dark salmon" :foreground "Black"))))
 '(ediff-fine-diff-B ((t (:background "dark green"))))
 '(ediff-odd-diff-A ((t (:background "saddle brown" :foreground "dark gray"))))
 '(ediff-odd-diff-B ((t (:background "dark red" :foreground "dark gray"))))
 '(sh-heredoc ((t (:foreground "medium sea green" :weight normal))))
 '(whitespace-space ((t (:background "sea green" :foreground "#073642"))))
 '(whitespace-tab ((t (:background "sea green" :foreground "#073642")))))

; Need this here so customization changes are used (dark background for solarized)
;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/emacs-color-theme-solarized")
;(load-theme 'wombat t)
;(load-theme 'zenburn t)
(load-theme 'solarized t)
;(load-theme 'tango-dark t)
(put 'dired-find-alternate-file 'disabled nil)
(put 'downcase-region 'disabled nil)
