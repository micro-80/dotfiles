(require 'tempel)

(defcustom notes-folder nil
  "Folder to save notes."
  :type 'string
  :group 'notes)

(defcustom notes-journal-folder nil
  "Folder to save journal notes."
  :type 'string
  :group 'notes)

(defun notes--make-string-path-safe (string delimit)
  (replace-regexp-in-string "_+$" ""
			    (replace-regexp-in-string (rx (1+ (not alnum))) delimit string)))

(defun notes--canonicalise (title tags extension)
  (let* ((date (format-time-string "%Y%0m%0dT%H%M%S"))
	 (title-canonicalised (notes--make-string-path-safe title "-"))
	 (tags-canonicalised (notes--make-string-path-safe tags "_"))
	 (file-name (format "%s--%s__%s%s" date title-canonicalised tags-canonicalised extension)))
    (expand-file-name file-name notes-folder)))

(defun notes--journal-canonicalise (name)
  (let ((file-name (format "%s.org" name)))
    (expand-file-name file-name notes-journal-folder)))

(defun notes--open-file-and-insert-template (path template)
  (let ((new-file (not (file-exists-p path))))
    (find-file path)
    (when new-file
      (let* ((templates (tempel--templates))
	     (tmpl (cl-find 'notes-new templates :key #'car :test #'eq)))
	(unless tmpl
	  (error "Template %s not found!" template))
	(tempel-insert tmpl)))))

(defun notes-create (title tags)
  "Create a new note with given TITLE and TAGS (comma separated)"
  (interactive (let ((title (read-string "Title: "))
		     (tags (read-string "Tags (comma separated, no spaces): ")))
		 (list title tags)))
  (let ((path (notes--canonicalise title tags ".org")))
    (notes--open-file-and-insert-template path "notes-new")))

;;;###autoload
(defun notes-journal-weekly ()
  "Fetch/create weekly journal entry"
  (interactive)
  (let* ((weekly (format-time-string "%Y-W%W"))
	 (path (notes--journal-canonicalise weekly)))
    (notes--open-file-and-insert-template path "notes-journal-weekly")))

;;;###autoload
(defun notes-journal-monthly ()
  "Fetch/create monthly journal entry"
  (interactive)
  (let* ((monthly (format-time-string "%YM%m"))
	 (path (notes--journal-canonicalise monthly)))
    (notes--open-file-and-insert-template path "notes-journal-monthly")))

;; TODO - separate a file name by its tags and title

(provide'notes)
