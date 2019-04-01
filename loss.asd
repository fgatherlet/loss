#|
  This file is a part of loss project.
  Copyright (c) 2019 fgatherlet (fgatherlet@gmail.com)
|#

#|
  lisp css library.

  Author: fgatherlet (fgatherlet@gmail.com)
|#

(defsystem "loss"
  :version "0.1.0"
  :author "fgatherlet"
  :license "MIT"
  :depends-on ("series"
               "let-over-lambda"
               "alexandria")
  :components ((:module "src"
                :components
                ((:file "loss"))))
  :description "lisp css library."
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "loss-test"))))
