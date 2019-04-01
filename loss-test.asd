#|
  This file is a part of loss project.
  Copyright (c) 2019 fgatherlet (fgatherlet@gmail.com)
|#

(defsystem "loss-test"
  :defsystem-depends-on ("prove-asdf")
  :author "fgatherlet"
  :license "MIT"
  :depends-on ("loss"
               "prove")
  :components ((:module "t"
                :components
                ((:test-file "test"))))
  :description "Test system for loss"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
