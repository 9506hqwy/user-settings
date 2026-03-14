;;; init.el --- Emacs initial script -*- lexical-binding: t; -*-

;; -*- coding: utf-8 -*-

;;; Commentary:

;;; Code:

(defun is-console ()
  "コンソール起動か判定する."
  (not (window-system)))

(defun is-windows ()
  "Windows かどうか判定する."
  (string-equal system-type 'windows-nt))

;; 起動時のメッセージを表示しない。
(setq-default inhibit-startup-screen t)

;; スクラッチバッファを空にする。
(setq-default initial-scratch-message nil)

;; デバックモード(無効)
(setq-default debug-on-error nil)

;; 既定のモード
(setq-default major-mode 'text-mode)

;; テーマ
(load-theme 'misterioso t)
(set-cursor-color "#a9a9a9")

;; メニューバーとツールバーを非表示
(menu-bar-mode 0)
(unless (is-console)
  (tool-bar-mode 0))

;; タイトルにファイル名を表示
(setq-default frame-title-format
  (format "%%f - emacs@%s" (system-name)))

;; モードラインに行番号と列番号を表示
(line-number-mode t)
(column-number-mode t)

;; 行番号を表示
(global-display-line-numbers-mode t)

;; スクロールバーを非表示
(unless (is-console)
  (scroll-bar-mode 0))

;; 行を折り返さない。(論理行を使用しない。)
(setq-default truncate-lines t)
(setq-default truncate-partial-width-windows t)

;; インデントは空白
(setq-default indent-tabs-mode nil)

;; 対応する括弧を色付け(かっこのみ強調)
(show-paren-mode t)
(setq-default show-paren-style 'parenthesis)

;; 改行コードを表示
(setq-default eol-mnemonic-dos "(CRLF)")
(setq-default eol-mnemonic-mac "(CR)")
(setq-default eol-mnemonic-unix "(LF)")

;; ダイアログボックスを未使用
(setq-default use-dialog-box nil)

;; 言語設定
(set-language-environment 'Japanese)
(if (is-windows)
    (prefer-coding-system 'cp932)
  (prefer-coding-system 'utf-8))
(if (is-windows)
    (setq-default default-file-name-coding-system 'cp932)
  (setq-default default-file-name-coding-system 'utf-8))
(if (is-windows)
    (setq-default default-process-coding-system '(cp932 . cp932))
  (setq-default default-process-coding-system '(utf-8 . utf-8)))
(if (is-windows)
    (setq-default default-frame-alist '((font . "ＭＳ ゴシック-12"))))

;; バッファの自動読み込み
(global-auto-revert-mode t)

;; 自動保存ファイルを削除
(setq-default delete-auto-save-files t)

;; 音を消す
(setq-default visible-bell t)
(setq-default ring-bell-function 'ignore)

;; 空白を表示(タブ、全角空白、改行をグリフ文字で表示)
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Useless-Whitespace.html
(require 'whitespace)
(setq-default whitespace-style '(face tabs tab-mark spaces space-mark newline newline-mark))
(setq-default whitespace-display-mappings
  '(
    (space-mark   ?\u3000 [?\u25a1]) ;; white box
    (tab-mark     ?\t [?\u21d2 ?\t]) ;; right arrow
    (newline-mark ?\n [?\u21b5 ?\n]) ;; cornor arrow
  ))
;; 空白は全角のみ
(setq-default whitespace-space-regexp "\\(\u3000+\\)")
(global-whitespace-mode t)

;; バッファのリスト表示
(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; 閉じた位置を保存
(require 'saveplace)
(save-place-mode t)

;; mini-buffer の履歴を保存
(require 'savehist)
(savehist-mode t)

;; 選択中の領域を削除後に挿入
(require 'delsel)
(delete-selection-mode t)

;; lisp
(require 'eldoc)
(setq-default eldoc-idle-delay 0.2)
(setq-default eldoc-echo-area-use-multiline-p t)
(add-hook 'emacs-lisp-mode-hook #'eldoc-mode)
(add-hook 'lisp-interaction-mode-hook #'eldoc-mode)

;; Emacs の Custom が書き込むファイルを外部化する。
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; 外部パッケージ設定
(require 'package)
;; 既定値
;; https://elpa.gnu.org/packages/
;; https://elpa.nongnu.org/nongnu/
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;;;;;;;;;;;;;;;;;;;
;; 外部パッケージ ;;
;;;;;;;;;;;;;;;;;;;;

;; use-package
;; https://elpa.gnu.org/packages//doc/use-package.html
;; 1. :preface section
;; 2. :init section
;; 3. load package
;; 4. :config section
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; Syntax checking for GNU Emacs
;; https://www.flycheck.org/en/latest/
(use-package flycheck
  :ensure t
  :init
    (global-flycheck-mode t)
  )

;; VERTical Interactive COmpletion
;; https://github.com/minad/vertico
(use-package vertico
  :ensure t
  :custom
    (vertico-cycle t)
    (vertico-resize t)
  :init
    (vertico-mode)
  )

;; COmpletion in Region FUnction
;; https://github.com/minad/corfu
(use-package corfu
  :ensure t
  :custom
    (corfu-cycle t)
    (corfu-preselect 'prompt)
    (corfu-auto t)
    (corfu-auto-delay 0.2)
    (corfu-auto-prefix 1)
  :init
    (global-corfu-mode t)
    (corfu-history-mode t)
    (corfu-popupinfo-mode t)
  )

;;  Corfu popup on terminal
;; https://codeberg.org/akib/emacs-corfu-terminal
(use-package corfu-terminal
  :ensure t
  :if (version< emacs-version "31")
  :unless (display-graphic-p)
  :after corfu
  :init
    (corfu-terminal-mode t)
  )

;; Let your completions fly!
;; https://github.com/minad/cape
(use-package cape
  :ensure t
  :init
    (add-hook 'completion-at-point-functions #'cape-dabbrev)
    (add-hook 'completion-at-point-functions #'cape-dict)
    (add-hook 'completion-at-point-functions #'cape-file)
    (add-hook 'completion-at-point-functions #'cape-history)
    (add-hook 'completion-at-point-functions #'cape-keyword)
  )

;; Language Server Protocol Support for Emacs
;; https://emacs-lsp.github.io/lsp-mode/
(use-package lsp-mode
  :ensure t
  :hook
    (python-mode . lsp)
  :custom
    (lsp-completion-provider :none)
  )

(use-package lsp-ui
  :ensure t
  )

(provide 'init)

;;; init.el ends here
