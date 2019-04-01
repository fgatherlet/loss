;; (ql:quickload :loss-test)
;; (ql:quickload :loss)
(defpackage loss-test
  (:use
   :cl
   :loss
   :prove))
(in-package :loss)
(use-package :prove)

;; NOTE: To run this test file, execute `(asdf:test-system :loss)' in your Lisp.

(plan nil)

(subtest "test0"
  (css
    (:span
     ((:padding 20 30))
     ))
  )

(subtest "test1"
  (css
    ((:or! :div :span) ;; eq "div, span"
     ((:margin 10))
     (:span
      ((:padding 20 30))
      ))
    )
  )

(subtest "test10"
  (css
    (:div
     ((:margin 10))
     ((:& .span)
      ((:padding 20 30))
      )
     ((:& "::active")
      ((:padding 20 30))
      ))
    )
  )

(subtest "test2"
  (css
    ((:or :div :span)
     ((:margin 10px))
     (:span
      ((:padding 20 30)))
     ((:or ".is-large" ".is-small")
      ((:font-size 20))
      )))
  )

(subtest "test30"
  (css
    ((:or :div :span)
     ((:margin 10px))
     (:span
      ((:padding 20 30)))
     ((:> ".is-large")
      ((:font-size 20))
      )))
  )

(subtest "test30"
  (css
    (:media
     "screen and (max-width: 1200px)"
     (:span
      ((:padding 20 30)))
     (".is-large"
      ((:font-size 20))
      )))
  )

(defmacro testmacro (x)
  (compile-decs
   `((:font-size ,x)
     (:font-weight "bold"))))

(defmacro testcssmacro (x)
  (compile-csss
   `((:dev
      ((:display ,x))))))

(subtest "test40"
  (css
    (:media
     "screen and (max-width: 1200px)"
     (:span
      ((:padding 20 30)
       (testmacro 99)
       ))
     (".is-large"
      ((:font-size 20))
      )))
  )

(subtest "test50"
  (css
    (:body
     ()
     (testcssmacro "boxbox")
     (:span
      ((:padding 20 30)
       (testmacro 99)
       ))
     (".is-large"
      ((:font-size 20))
      )))
  )

(finalize)
