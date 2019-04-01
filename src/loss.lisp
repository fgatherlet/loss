(defpackage loss
  (:export
   :css
   )
  (:use
   :cl
   :series
   ))
(in-package :loss)

(defvar *env* nil)
(defvar *level* 0)

(defun indent ()
  (make-string (* 2 (max 0 *level*)) :initial-element #\space))

(defgeneric compile-css-list (head-head head-body decs children))

(defun newenv (head-head head-body)
  (when (and (null *env*) head-head)
    (error "head-head should be nil when *env* is nil"))
  ;;(format t "[~s][~s]~%" head-head *level*)
  (cond
    ((null head-head)
     (if *env*
         (format nil "~a ~(~a~)" *env* head-body)
       (format nil "~(~a~)" head-body)))
    ((eql :& head-head)
     (format nil "~a~(~a~)" *env* head-body))
    ((member head-head '(:> :~ :+))
     (format nil "~a ~a ~(~a~)" *env* head-head head-body))
    (t
     (error "unknown head-head:~s" head-head))))

(defmacro css (&body children)
  (let ((fn (compile-csss children)))
    (funcall fn)))

(defun compile-csss (xs)
  (let ((xs (mapcar #'compile-css xs)))
    (lambda ()
      (dolist (x xs)
        (funcall x)))))

;; ------------------------------

(defun compile-css (x)
  (check-type x list)
  (destructuring-bind (head &rest body) x
    (cond
      ((listp head)
       (compile-css-list (car head) (cdr head) (car body) (cdr body)))
      ((eql :media head)
       (compile-css-media (car body) (cdr body)))
      ((and head (symbolp head) (not (keywordp head)))
       (eval (cons head body)))
      ;;(destructuring-bind (head decs &rest children) x
      ;;  (cond
      ;;    ((listp head)
      ;;     (compile-css-list (car head) (cdr head) decs children))
      ;;    ((eql :media head)
      ;;     (compile-css-media decs children))
      (t
       (compile-css-list nil (list head) (car body) (cdr body))))))

;; ------------------------------

(defun compile-dec (head &rest rest)
  (cond
    ((keywordp head)
     (lambda ()
       (format t "~a  ~(~a~): ~{~(~a~)~^ ~};~%" (indent) head rest)))
    ((eql 'cl:lambda head)
     (eval (cons head rest)))
    ;; macro expand
    ((symbolp head)
     (eval (cons head rest)))
    (t
     (lambda ()
       (error "wip call function")))))

;; ------------------------------

(defun compile-decs (decs)
  (let ((decs (mapcar (lambda (x) (apply #'compile-dec x)) decs)))
    (lambda ()
      (dolist (dec decs)
        (funcall dec)))))

;; ------------------------------

(defun compile-css-media (query children)
  (let ((children (mapcar #'compile-css children)))
    (lambda ()
      (let ((*level* 1))
        (format t "~&@media ~a {~&" query)
        (dolist (child children)
          (funcall child))
        (format t "}~&")))))

;; ------------------------------

(defmethod compile-css-list ((head-head (eql :or)) (head-body list) decs children)
  (let ((fns (mapcar (lambda (head)
                       (compile-css-list nil (list head) decs children))
                     head-body)))
    (lambda ()
      (dolist (fn fns)
        (funcall fn)))))

(defmethod compile-css-list ((head-head (eql :or!)) (head-body list) decs children)
  (compile-css-list nil (list (format nil "~{~a~^, ~}" head-body)) decs children))

(defmethod compile-css-list ((head-head t) (head-body list) decs children)
  (assert (= 1 (length head-body)))
  (let ((decs (compile-decs decs))
        (children (mapcar #'compile-css children)))
    (lambda ()
      (let ((*env* (newenv head-head (car head-body)))
            ;;(*level* (1+ *level*))
            )
        ;;(format t "[~s]~%" *level*)
        (format t "~&~a~a {~&" (indent) *env*)
        (funcall decs)
        (format t "~&~a}~&" (indent))
        (dolist (child children)
          (funcall child))))))
