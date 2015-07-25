;;;;;;;;;;;;;;;;;;;;;
;; general setting ;;
;;;;;;;;;;;;;;;;;;;;;


;; add my local elisp files to load-path
;; http://masutaka.net/chalow/2009-07-05-3.html
(defconst my-elisp-directory "~/.emacs.d/elisp" "The directory for my elisp file.")
(dolist (dir (let ((dir (expand-file-name my-elisp-directory)))
               (list dir (format "%s%d" dir emacs-major-version))))
  (when (and (stringp dir) (file-directory-p dir))
    (let ((default-directory dir))
      (add-to-list 'load-path default-directory)
      (normal-top-level-add-subdirs-to-load-path))))

;; move to a top/bottom (right most) line in a visible buffer
(defun move-top-line-visible ()
  (interactive)
  (move-to-window-line-top-bottom 0))
(defun move-bottom-line-visible ()
  (interactive)
  (move-to-window-line-top-bottom -1))
(defun move-right-column-visible ()
  (interactive)
  (let ((pos1 (save-excursion (move-beginning-of-line 1) (point)))
	(pos2 (save-excursion (move-end-of-line 1) (point))))
    (progn (goto-char (min (+ pos1 (window-width)) pos2)))
    ))
(defun recenter-horizontally ()
  (interactive)
  (let ((mid (/ (window-width) 2))
        (line-len (save-excursion (end-of-line) (current-column)))
        (cur (current-column)))
    (if (< mid cur)
        (set-window-hscroll (selected-window)
                            (- cur mid)))))

;; pwd in emacs shell
(defun shell-pwd ()
  "able to <pwd> quickly in emacs"
  (interactive)
  (save-window-excursion
    (shell-command "pwd")))

;; marmalade
;; http://marmalade-repo.org/
(require 'package)
(add-to-list 'package-archives 
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(package-initialize)

;; setting for PATH in emacs shell (this code must be executed after the above "marmalade" something)
;; http://qiita.com/catatsuy/items/3dda714f4c60c435bb25
(require 'exec-path-from-shell)
(exec-path-from-shell-initialize)

;; for typing backslash
;; http://blog.ohgaki.net/mac-osx-10-6-aquaemacs-unicode-y
(define-key global-map [?¥] [?\\])
(define-key global-map [?\C-¥] [?\C-\\])
(define-key global-map [?\M-¥] [?\M-\\])
(define-key global-map [?\C-\M-¥] [?\C-\M-\\])

;; setting of ispell's personal dictionary (aspell)
(setq ispell-program-name "aspell")
(setq ispell-personal-dictionary (expand-file-name "~/Dropbox/mydoc/programs/emacs/.aspell.en.pws"))

;; auctex costumize
(add-hook 'LaTeX-mode-hook
          (lambda()
 	    (add-to-list 'TeX-command-list '("Make" "latexmk %s"
 					     TeX-run-command nil t :help "Run Latexmk on file") t)
 	    (setq TeX-command-default "Make")
	    (add-to-list 'TeX-command-list '("JumpToSkim"
					     "/Applications/Skim.app/Contents/SharedSupport/displayline %n %s.pdf %b"
					     TeX-run-command nil t :help "Jump to Skim According to Cursor") t)
	    ))

(server-start); start emacs in server mode so that skim can talk to it


;; scroll one line (or one column) at a time smoothly (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq hscroll-step 1)
(setq hscroll-margin 1)
(defun scroll-left2 ()
  (interactive)
  (scroll-left 2))
(defun scroll-right2 ()
  (interactive)
  (scroll-right 2))

;; dired 
;;(setq dired-recursive-copies (quote always)) ; “always” means no asking
;;(setq dired-recursive-deletes (quote top)) ; “top” means ask once

;; open diary.txt as org-mode
(setq auto-mode-alist
      (cons '("diary.txt" . org-mode) auto-mode-alist))

;; japanese font setting
(set-fontset-font
 "fontset-default" 'japanese-jisx0208
 (font-spec :family "Osaka"))

(defun open-from-dired ()
  "open a file above the cursor in dired-mode"
  (interactive)
  (save-window-excursion
    (shell-command (concat "open \"" (dired-get-filename) "\" &"))))
(add-hook 'dired-mode-hook
 	  (lambda () (local-set-key "\C-c\C-o" 'open-from-dired)))


;; omit needless GUI
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(setq frame-title-format "%b")
(add-hook 'after-make-frame-functions
          '(lambda (frame)
             (modify-frame-parameters frame
                                      '((vertical-scroll-bars . nil)
                                        (horizontal-scroll-bars . nil)))))

;; from kisojikken
(windmove-default-keybindings)
(show-paren-mode 1)
(setq gdb-many-windows t)

;; japanese charcter code
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; browser setting
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "/usr/bin/open")
;; (global-set-key (kbd "C-c C-b") 'browse-url)


;; vocabulary search command
(defun search-in-alc ()
  "search for a word under cursor in alc web dictionary"
  (interactive)
  (save-window-excursion
    (shell-command (concat "open \"http://eow.alc.co.jp/search?q=" (thing-at-point 'line) "\""))))


;; cut & paste
(cond (window-system
       (setq x-select-enable-clipboard t)
       ))

;; display the point of cursor as (row, column)
(setq column-number-mode t)

;; changing background color
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "black" :foreground "#55FF55"))))
 '(cursor ((((class color) (background dark)) (:background "#00AA00")) (((class color) (background light)) (:background "#999999")) (t nil))))

;; handling rectangle-area
(cua-mode t)
(setq cua-enable-cua-keys nil)

;; elscreen (tab change keybind, open file in dired) (install from apt)
(load "elscreen" "ElScreen" t)
(defun elscreen-find-file-in-dired () "" (interactive)
  (elscreen-find-file (dired-get-file-for-visit)))
(add-hook 'dired-mode-hook
 	  (lambda () (local-set-key (kbd "C-z C-o") 'elscreen-find-file-in-dired)))


;; For US keyboard 
(add-hook 'dired-mode-hook
 	  (lambda () (local-set-key (kbd "-") 'dired-up-directory)))


;; kill and close buffer
(defun my-kill-close-buffer ()
  "killing and closing"
  (interactive)
  (progn
    (kill-process)
    (kill-buffer)
    (delete-window)))


;; open file/directory convenience
;; (defun myopen-file-under-cursor (pathname)
;;   "open a file under the cursor"
;;   ;; (interactive "sPrefix: ")
;;   (interactive
;;    (list (read-string (format "file path (%s): " (thing-at-point 'filename))
;; 		      (thing-at-point 'filename) nil (thing-at-point 'filename))))
;;   (elscreen-find-file pathname))

    
;; toggle a division type, virtically and horizontally (http://www.bookshelf.jp/soft/meadow_30.html)
(defun window-toggle-division ()
  "toggle a division type of a frame between virtically/horizontally"
  (interactive)
  (unless (= (count-windows 1) 2)
    (error "this frame is not divided into 2 windows."))
  (let (before-height (other-buf (window-buffer (next-window))))
    (setq before-height (window-height))
    (delete-other-windows)
    (if (= (window-height) before-height)
        (split-window-vertically)
      (split-window-horizontally)
      )
    (switch-to-buffer-other-window other-buf)
    (other-window -1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; my local key bindings ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; see [http://stackoverflow.com/questions/683425/globally-override-key-binding-in-emacs]
(defvar my-keys-minor-mode-map
  (let ((map (make-keymap)))
    ;; elscreen
    (define-key map (kbd "<C-tab>") 'elscreen-next)
    (define-key map (kbd "<S-C-tab>") 'elscreen-previous)
    ;; comment/uncomment
    (define-key map (kbd "C-<") 'comment-region)
    (define-key map (kbd "C->") 'uncomment-region)
    ;; change window size
    ;; (define-key map (kbd "S-C-<down>") 'shrink-window)
    ;; (define-key map (kbd "S-C-<up>") 'enlarge-window)
    ;; (define-key map (kbd "S-C-<left>") 'shrink-window-horizontally)
    ;; (define-key map (kbd "S-C-<right>") 'enlarge-window-horizontally)
    (define-key map (kbd "S-C-n") 'shrink-window)
    (define-key map (kbd "S-C-p") 'enlarge-window)
    (define-key map (kbd "S-C-<left>") 'shrink-window-horizontally)
    (define-key map (kbd "S-C-<right>") 'enlarge-window-horizontally)
    ;; toggle division
    (define-key map (kbd "C-c C-s") 'window-toggle-division)
    ;; toggle truncatation
    (define-key map (kbd "C-c t") 'toggle-truncate-lines)
    ;;
    ;; (define-key map (kbd "C-c C-p") 'move-top-line-visible)
    ;; (define-key map (kbd "C-c C-n") 'move-bottom-line-visible)
    ;; (define-key map (kbd "C-c C-e") 'move-right-column-visible)
    ;; (define-key map (kbd "C-c C-l") 'recenter-horizontally)
    (define-key map (kbd "<M-wheel-down>") 'scroll-left2)
    (define-key map (kbd "<M-wheel-up>") 'scroll-right2)
    ;; (define-key map (kbd "s-p") 'shell-pwd)
    (define-key map (kbd "s-n") 'cua-scroll-up)
    (define-key map (kbd "s-p") 'cua-scroll-down)
    (define-key map (kbd "C-c C-b") 'browse-url)
    (define-key map (kbd "C-'") 'cua-set-mark)
    ;; (define-key map (kbd "C-c C-n") 'search-in-alc)
    (define-key map (kbd "C-x C-k") 'my-kill-close-buffer)
    (define-key map (kbd "C-c C-o") 'myopen-file-under-cursor)
    map)
  "my-keys-minor-mode keymap.")
(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " my-keys" 'my-keys-minor-mode-map)
(my-keys-minor-mode 1)
(defun my-minibuffer-setup-hook () ;; except minibuffer
  (my-keys-minor-mode 0))
(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)


;;;;;;;;;;;;;;;;;;;;;;;;
;; some other setting ;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; for coq with proofgeneral
(load-file (expand-file-name "~/.emacs.d/elisp/ProofGeneral-4.2/generic/proof-site.el"))

;; ruby-mode for Rakefile, *.rake
(setq auto-mode-alist
      (append '(("\\.rake" . ruby-mode) ("Rakefile" . ruby-mode))
	      auto-mode-alist))

;; hoogle keybind (http://www.haskell.org/haskellwiki/Hoogle)
(global-set-key (kbd "C-h C-u") 'hoogle)

;; haskell Definition Helper, hoogle keybinding
(defun hs-definition-helper (name) "definition helper" (interactive "sFunction Name: ")
 (let ((text (concat name " :: \n" name " =")))
   (progn (insert text)
	   (previous-line)
	   (move-end-of-line nil))))
(add-hook 'haskell-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c C-e") 'hs-definition-helper)
	    (local-set-key (kbd "C-h C-u") 'hoogle)))
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;; markdown-mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(defun my-jekyll-put-github (url)
  "jekyll github tag generator"
  (interactive "sURL: ")
  (insert (concat "{% github "
                    "{"
                    " \"url\":     "  "\"" url "\","
		    " \"start\":   "             ","
		    " \"end\":     "             ","
		    " \"lang\": \"\" "
                    "}"
                  "%}")))

(defun my-jekyll-put-highlight (lang)
  "jekyll highlight tag generator"
  (interactive "sLanguage Name: ")
  (insert (concat "{% highlight " lang " %}\n\n{% endhighlight %}"))
  (previous-line))

(require 'json)
(require 'cl-lib)
(defun get-string-from-file (filePath)
  "Return filePath's file content."
  (with-temp-buffer
    (insert-file-contents filePath)
    (buffer-string)))

(defun my-jekyll-open-local ()
  (interactive)
  (let* ((current-lineno (line-number-at-pos))
	 (jekyll-local-root "/Users/hiogawa/repositories/github_public/myblog_jekyll")
	 (jekyll-host       "http://localhost:4000")
	 (json-file (concat jekyll-local-root
			    "/_sync/"
			    (file-name-nondirectory (buffer-file-name (current-buffer)))
			    ".json"))
	 (json-string (get-string-from-file json-file))
	 (json-obj (json-read-from-string json-string))
	 (url (cdr (assoc 'url json-obj)))
	 (ups (cl-remove-if-not (lambda (o) (<= (cdr (assoc 'lineno o)) current-lineno))
				(cdr (assoc 'jump json-obj))))
	 (sort-ups (cl-sort ups
			    (lambda (p q) 
			      (> (cdr (assoc 'lineno p)) (cdr (assoc 'lineno q))))))
	 (id (cdr (assoc 'id (elt sort-ups 0)))))
    (shell-command (concat "osascript -l JavaScript "
			   "/Users/hiogawa/Dropbox/mydoc/programs/applescript/"
			   "smart_jump_to_chrome.scpt "
			   jekyll-host url " " id))))

(add-hook 'markdown-mode-hook 
	  (lambda ()
	    (local-set-key (kbd "C-c C-g") 'my-jekyll-put-github)
	    (local-set-key (kbd "C-c C-l") 'my-jekyll-open-local)
	    (local-set-key (kbd "C-c C-h") 'my-jekyll-put-highlight)))


;; inserted by the command
;; $ agda-mode setup
(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))

(setq agda2-unicode-list '(
			   ("e" . "Σ[ ∈ ] ()")  ;; exists 
			   ("n" . "¬")   ;; not 
			   ("a" . "×")   ;; and
			   ("o" . "⊎")  ;; or
			   ("eq" . "≡") ;; equality
			   ))

(defun agda2-unicode (arg) "" (interactive "s: ")
  (insert (cdr (assoc arg agda2-unicode-list))))


(add-hook 'agda2-mode-hook
	  (lambda ()
	    (add-to-list 'agda2-include-dirs 
			 (expand-file-name "~/Dropbox/mydoc/programs/agda/stdlib/lib-0.7/src"))
	    (local-set-key (kbd "C-c C-g") 'agda2-give)
	    (local-set-key (kbd "M-U") 'agda2-unicode)
	    ;; (setq agda2-highlight-face-groups 'default-faces)
	    ))


;; coq
;; hide "goals" "response" buffers
(defun my-coq-buffers-hide () "" (interactive)
  (enlarge-window 30))

(add-hook 'coq-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c C-k") 'my-coq-buffers-hide)
	    ))


;; prevent crashes by gui popup dialogs
;; http://superuser.com/questions/125569/how-to-fix-emacs-popup-dialogs-on-mac-os-x
(defadvice yes-or-no-p (around prevent-dialog activate)
  "Prevent yes-or-no-p from activating a dialog"
  (let ((use-dialog-box nil))
    ad-do-it))
(defadvice y-or-n-p (around prevent-dialog-yorn activate)
  "Prevent y-or-n-p from activating a dialog"
  (let ((use-dialog-box nil))
    ad-do-it))


;; scilab setup
;; (load "scilab-startup")

;; (defun my-scilab-region-execute ()
;;   "execute a region"
;;   (interactive)
;;   (unless (and (= (count-windows 1) 2) ;; check window/buffer is applicable
;; 	       (eq (buffer-local-value
;; 		    'major-mode
;; 		    (window-buffer (nth 1 (window-list-1 nil))))
;; 		   'shell-mode))
;;     (error "you need a shell-mode buffer in the other window"))
;;   (let ((text (buffer-substring (region-beginning) (region-end))))
;;     (save-window-excursion
;;       (other-window 1) ;; move to shell buffer
;;       (insert text)
;;       (comint-send-input)
;;       (end-of-buffer))))

;; (defun my-scilab-line-execute ()
;;   "execute the line under the cursor"
;;   (interactive)
;;   (unless (and (= (count-windows 1) 2) ;; check window/buffer is applicable
;; 	       (eq (buffer-local-value
;; 		    'major-mode
;; 		    (window-buffer (nth 1 (window-list-1 nil))))
;; 		   'shell-mode))
;;     (error "you need a shell-mode buffer in the other window"))
;;   (let* ((l (thing-at-point 'line))
;; 	 (text (substring l 0 (- (length l) 1))))
;;   ;; (let ((text ((thing-at-point 'line))))
;;     (save-excursion
;;       (other-window 1) ;; move to shell buffer
;;       (insert text)
;;       (comint-send-input)
;;       (end-of-buffer)
;;       (other-window 1))))

;; (defun my-scilab-show-variable ()
;;   "show the value of a variable"
;;   (interactive)
;;   (let ((sym (thing-at-point 'symbol)))
;;     (save-window-excursion
;;       (other-window 1)
;;       (insert sym)
;;       (comint-send-input)
;;       (end-of-buffer))))

;; (add-hook 'scilab-mode-hook
;; 	  (lambda ()
;; 	    (local-set-key (kbd "C-c C-r") 'my-scilab-region-execute)
;; 	    (local-set-key (kbd "C-c C-l") 'my-scilab-line-execute)
;; 	    (local-set-key (kbd "C-c C-o") 'my-scilab-show-variable)
;; 	    ))




;; octave mode
;; (add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))

(defun my-octave-show-variable ()
  "show the value of a variable"
  (interactive)
  (let ((sym (thing-at-point 'symbol)))
    (save-window-excursion
      (other-window 1)
      (insert sym)
      (comint-send-input)
      (end-of-buffer))))
(defun my-octave-show-variable ()
  "show the value of a variable"
  (interactive)
  (let* ((b (bounds-of-thing-at-point 'symbol))
	 (beg (car b))
	 (end (cdr b)))
    (octave-send-region beg end)))

(add-hook 'octave-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c C-j") 'octave-send-region)
	    (local-set-key (kbd "C-c C-n") 'octave-send-line)
	    (local-set-key (kbd "C-c C-e") 'octave-kill-process)
	    (local-set-key (kbd "C-c C-o") 'my-octave-show-variable)
	    ))

;; inf-ruby
(add-hook 'ruby-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c C-j") 'ruby-send-region)
	    (local-set-key (kbd "C-c C-n") 'ruby-send-definition)
	    ))

;; haml-mode
(require 'haml-mode)

;; emacs shell
(defun myshell-put-head-pipe ()
  "put \"| head -n 40\" to avoid the warning comes
   from the lack of functionality of emacs shell"
  (interactive)
  (insert "| head -n 40"))

(defun myshell-put-thing-at-command-line ()
  "put thing at point to the command line"
  (interactive)
  (let ((original_point (point))
	(path_name (thing-at-point 'filename)))
    (end-of-buffer)
    (insert (concat " " path_name))
    (goto-char original_point)))

(add-hook 'shell-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c C-h") 'myshell-put-head-pipe)
	    (local-set-key (kbd "C-c <C-return>") 'myshell-put-thing-at-command-line)
	    ))

;; invoke css mode for .scss files
(add-to-list 'auto-mode-alist '("\\.scss\\'" . css-mode))

;; objective-c
(add-to-list 'auto-mode-alist '("\\.m\\'" . objc-mode))
(add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . objc-mode))
(add-to-list 'auto-mode-alist '("\\.xm\\'" . objc-mode))


;; coffee mode (from ~/.emacs.d/elpa/coffee-mode-readme.txt)
(defun coffee-custom ()
  "coffee-mode-hook"
  ;; CoffeeScript uses two spaces.
  (make-local-variable 'tab-width)
  (set 'tab-width 2)
)
(add-hook 'coffee-mode-hook 'coffee-custom)


(defun my-run-rake ()
  "watch local file updates and run rake"
  (shell-command "rake"))
(define-minor-mode my-watch-rake-mode
  "watch local file updates and run rake"
  :lighter "Watch Rake"
  (cond
   (my-watch-rake-mode
    (add-hook 'after-save-hook 'my-run-rake nil t))
   (t
    (remove-hook 'after-save-hook 'my-run-rake t))))


;; you can set a value from any buffer by Alt-key + collon(:)
(setq my-watch-command-string "pwd")

(defun my-watch-command()
  (interactive)
  "see my-watch-file-save"
  (shell-command my-watch-command-string))

(define-minor-mode my-watch-file-save
  "watch local file updates and run command set by 'my-watch-command'"
  :lighter " my-watch"
  (cond
   (my-watch-file-save
    (add-hook 'after-save-hook 'my-watch-command nil t))
   (t
    (remove-hook 'after-save-hook 'my-watch-command t))))

;; (defun my-run-rake-rsync ()
;;   "watch local file updates and run rake"
;;   (shell-command "rake rsync"))
;; (define-minor-mode my-watch-rails-rsync-mode
;;   "watch local file updates and run rake rsync"
;;   :lighter "Watch Rails Rsync"
;;   (cond
;;    (my-watch-rails-rsync-mode
;;     (add-hook 'after-save-hook 'my-run-rake-rsync nil t))
;;    (t
;;     (remove-hook 'after-save-hook 'my-run-rake-rsync t))))

