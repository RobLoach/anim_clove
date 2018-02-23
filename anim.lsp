(do 
  ; Author: Muresan Vlad Mihail 
  ; Date: 23.02.2018 
  ; Desc: Class wich helps you make animations in CLove using Aria

  (= anim:img (fn (lsp) (car lsp)))
  (= anim:w (fn (lsp) (car (cdr lsp))))
  (= anim:h (fn (lsp) (car (nthcdr lsp 1))))
  (= anim:fx (fn (lsp) (car (nthcdr lsp 2))))
  (= anim:fy (fn (lsp) (car (nthcdr lsp 3))))
  (= anim:frames (fn (lsp) (car (nthcdr lsp 4))))
  (= anim:img-w (fn (lsp) (car (nthcdr lsp 5))))
  (= anim:img-h (fn (lsp) (car (nthcdr lsp 6))))
  (= anim:curr-frame (fn (lsp) (car (nthcdr lsp 7)))) 
  (= anim:curr-speed (fn (lsp) (car (nthcdr lsp 8))))
  (= anim:loop (fn (lsp) (car (nthcdr lsp 9))))
  (= anim:stop (fn (lsp) (car (nthcdr lsp 10))))
  (= anim:custom (fn (lsp) (car (nthcdr lsp 11))))
  (= anim:stop-frame (fn (lsp) (car (nthcdr lsp 12))))
  (= anim:start-frame (fn (lsp) (car (nthcdr lsp 13))))
  (= anim:f (fn (lsp) (car (nthcdr lsp 14))))
  (= anim:speed (fn (lsp) (car (nthcdr lsp 15))))

  (= set:anim-img (fn (lsp val) (setcar lsp val)))
  (= set:anim-w (fn (lsp val) (setcar (cdr lsp) val)))
  (= set:anim-h (fn (lsp val) (setcar (nthcdr lsp 1) val)))
  (= set:anim-fx (fn (lsp val) (setcar (nthcdr lsp 2) val)))
  (= set:anim-fy (fn (lsp val) (setcar (nthcdr lsp 3) val)))
  (= set:anim-frames (fn (lsp val) (setcar (nthcdr lsp 4) val)))
  (= set:anim-img-w (fn (lsp val) (setcar (nthcdr lsp 5) val)))
  (= set:anim-img-h (fn (lsp val) (setcar (nthcdr lsp 6) val)))
  (= set:anim-curr-frame (fn (lsp val) (setcar (nthcdr lsp 7) val)))
  (= set:anim-curr-speed (fn (lsp val) (setcar (nthcdr lsp 8) val)))
  (= set:anim-loop (fn (lsp val) (setcar (nthcdr lsp 9) val)))
  (= set:anim-stop (fn (lsp val) (setcar (nthcdr lsp 10) val)))
  (= set:anim-custom (fn (lsp val) (setcar (nthcdr lsp 11) val)))
  (= set:anim-stop-frame (fn (lsp val) (setcar (nthcdr lsp 12) val)))
  (= set:anim-start-frame (fn (lsp val) (setcar (nthcdr lsp 13) val)))
  (= set:anim-f (fn (lsp val) (setcar (nthcdr lsp 14) val)))
  (= set:anim-speed (fn (lsp val) (setcar (nthcdr lsp 15) val)))


  [= anim:create 
	 [fn (img width height)
		 (list img width height 0 0 0 
			   (love:graphics-image-getWidth img)
			   (love:graphics-image-getHeight img)
			   1 0 t nil nil nil 1 0 0)]]

  [= anim:_makeFrame 
	 [fn (lsp) 
		 [ when (eq (anim:f lsp) 0) 
				; Equation: f = floor(imgW / w * imgH / h)
				(set:anim-f lsp ( floor (* (/ (anim:img-w lsp) (anim:w lsp)) (/ (anim:img-h lsp) (anim:h lsp) ))))] 

		 (set:anim-fx lsp (floor (/ (anim:img-w lsp) (anim:w lsp))))

		 (= add (list nil))
		 [ dotimes (= i 1) (+ (anim:f lsp) 1)
				   (= row (floor (/ (- i 1) (anim:fx lsp))))
				   (= column (mod (- i 1) (anim:fx lsp)))
				   (= add (append add (love:graphics-newQuad 
										(* column (anim:w lsp))
										(* row (anim:h lsp))
										(anim:w lsp)
										(anim:h lsp)
										(anim:img-w lsp)
										(anim:img-h lsp))))
				   (set:anim-frames lsp add)]]]


  [= anim:add 
	 [fn (lsp start_frame stop_frame speed)

		 (anim:_makeFrame lsp)
		 (set:anim-stop-frame lsp stop_frame)
		 (set:anim-start-frame lsp start_frame)
		 (set:anim-speed lsp speed) 	

		 ]]

  [= anim:draw 
	 [fn (lsp x y rot sx sy kx ky)
		 (= rot (if (not rot) 0 rot))
		 (= sx (if (not sx) 1 sx))
		 (= sy (if (not sy) 1 sy))
		 (= kx (if (not kx) 0 kx))
		 (= ky (if (not ky) 0 ky))

		 [if (not (endp (anim:frames lsp)))
		   [love:graphics-drawQuad 
			 (anim:img lsp)
			 (nth (anim:frames lsp) (anim:curr-frame lsp))
			 x y rot sx sy kx ky]

		   (love:graphics-drawImage (anim:img lsp) x y rot sx sy kx ky)]
		 ]]

  [= anim:play [fn (lsp t_loop)
				   [if (endp (anim:stop lsp))
					 [do
					   (set:anim-loop lsp t_loop)
					   (set:anim-curr-speed lsp (+ (anim:curr-speed lsp) (love:timer-getDelta)))
					   ; increment current frame if needed 
					   (when (> (anim:curr-speed lsp) 0)
						 (when (and (eq (anim:curr-frame lsp) 0) (>= (anim:start-frame lsp) 1) )
						   (set:anim-curr-frame lsp (anim:start-frame lsp)))
						 (when (>= (anim:curr-speed lsp ) (anim:speed lsp))
						   (set:anim-curr-frame lsp (+ (anim:curr-frame lsp ) 1))
						   (set:anim-curr-speed lsp 0)))
					   |#
					   -- Note:
					   -- When you have no speed attached to your animation that means
					   -- you want to play only the first quad added in 'add' function
					   #|
					   (when (eq (anim:speed lsp ) 0)
						 (set:anim-curr-frame lsp (anim:start-frame lsp)))

					   (if (eq (anim:stop-frame lsp ) endp)
						 ; We don't have a stop frame 
						 (do 
						   (if (> (anim:curr-frame lsp ) (length (anim:frames lsp)))
							 (do
							   (if (eq (anim:loop lsp) t) 
								 (when (>= (anim:start-frame lsp) 1) 
								   (set:anim-curr-frame lsp (anim:start-frame lsp)))
								 (set:anim-curr-frame lsp 1)))
							 (set:anim-curr-frame lsp (length (anim:frames lsp)))
							 ))
						 ; We have a stop frame 
						 (when (> (anim:curr-frame lsp ) (anim:stop-frame lsp))
						   (if (eq (anim:loop lsp ) t)
							 (when (> (anim:start-frame lsp ) 0) 
							   (set:anim-curr-frame lsp (anim:start-frame lsp)))
							 (set:anim-curr-frame lsp (anim:stop-frame lsp))
							 )
						   )		   )
					   ]]]]

  )
