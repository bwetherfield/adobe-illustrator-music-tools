;; NOTE:
;; The following is an include file that comes with Lilypond.
;; set-global-staff-size value of 20 ensures the symbols the engraving
;; of which this file triggers are proportional to a staff size of 7mm
;; which is standard (and the size of staff I wanted to import)


#(set-global-staff-size 20)

#(begin

  ;; some helper functions

  (use-modules (ice-9 regex))

  (define glyph-list
    (delete ".notdef"
            (ly:otf-glyph-list (ly:system-font-load "emmentaler-20"))))

  (define (get-group glyph-list regexp)
    (let ((r (make-regexp regexp)))
      (filter (lambda (token) (regexp-exec r token))
              glyph-list)))

  ;;;;;;;;;

  ;; extract ancient-music groups before extracting default
  ;; accidentals, rests, etc. to prevent duplication

  ;; make sure "mensural" regexp doesn't match "neomensural"
  (define neomensural (get-group glyph-list "^.*neomensural.*$"))
  (define mensural
    (filter (lambda (x) (not (member x neomensural)))
            (get-group glyph-list "^.*mensural.*$")))

  ;; get the rest of the ancient-music groups
  (define vaticana (get-group glyph-list "^.*vaticana.*$"))
  (define medicaea (get-group glyph-list "^.*medicaea.*$"))
  (define hufnagel (get-group glyph-list "^.*hufnagel.*$"))
  (define petrucci (get-group glyph-list "^.*petrucci.*$"))
  (define solesmes (get-group glyph-list "^.*solesmes.*$"))
  (define kievan (get-group glyph-list "^.*kievan.*$"))

  ;; remove ancient-music groups from the glyph-list
  (for-each
    (lambda (x) (set! glyph-list (delete x glyph-list)))
    (append vaticana
            medicaea
            hufnagel
            mensural
            neomensural
            petrucci
            solesmes
            kievan))

  ;; define all remaining groups
  (define numbers
    '("plus" "comma" "hyphen" "period"
      "zero" "one"   "two"    "three"  "four"
      "five" "six"   "seven"  "eight"  "nine"))

  (define dynamics
    '("space" "f" "m" "p" "r" "s" "z"))

  (define default-noteheads
    (get-group glyph-list
      "^noteheads.[dsu]M?[012]$"))

  (define special-noteheads
    (get-group glyph-list
      "^noteheads.[dsu]M?[012](double|harmonic|diamond|cross|xcircle|triangle|slash)$"))

  (define shape-note-noteheads
    (get-group glyph-list
      "^noteheads.[dsu][012](do|re|mi|fa|sol|la|ti)(Thin|Mirror|Funk|Walker)*$"))

  (define clefs       (get-group glyph-list "^clefs\\."))
  (define timesig     (get-group glyph-list "^timesig\\."))
  (define accidentals (get-group glyph-list "^accidentals\\."))
  (define rests       (get-group glyph-list "^rests\\."))
  (define flags       (get-group glyph-list "^flags\\."))
  (define dots        (get-group glyph-list "^dots\\."))
  (define scripts     (get-group glyph-list "^scripts\\."))
  (define arrowheads  (get-group glyph-list "^arrowheads\\."))
  (define brackettips (get-group glyph-list "^brackettips\\."))
  (define pedal       (get-group glyph-list "^pedal\\."))
  (define accordion   (get-group glyph-list "^accordion\\."))
  (define ties   (get-group glyph-list "^ties\\."))

  ;; remove all remaining groups from the glyph-list
  (for-each
    (lambda (x) (set! glyph-list (delete x glyph-list)))
    (append numbers
            dynamics
            default-noteheads
            special-noteheads
            shape-note-noteheads
            clefs
            timesig
            accidentals
            rests
            flags
            dots
            scripts
            arrowheads
            brackettips
            pedal
            accordion
            ties))

  ;;;;;;;;;

  ;; require all glyphs to appear here
  (if (pair? glyph-list) ; glyph-list should be empty by now
      (ly:error
        (_ "Unlisted glyphs in Documentation/included/font-table.ly: ~A")
        glyph-list))

) % end of (begin ...)

\paper {
  %% ugh. text on toplevel is a bit broken...

  oddHeaderMarkup = \markup {}
  evenHeaderMarkup = \markup {}
  oddFooterMarkup = \markup {}
  evenFooterMarkup = \markup {}
  }

\version "2.16.0"

#(define-markup-command (doc-char layout props name) (string?)
  (interpret-markup layout props
   (let* ((n (string-length name)))
     (if (> n 24)
	 ;; split long glyph names near the middle at dots
	 (let* ((middle-pos (round (/ n 2)))
		(left-dot-pos (string-rindex name #\. 0 middle-pos))
		(right-dot-pos (string-index name #\. middle-pos))
		(left-distance (if (number? left-dot-pos)
				   (- middle-pos left-dot-pos)
				   middle-pos))
		(right-distance (if (number? right-dot-pos)
				    (- right-dot-pos middle-pos)
				    middle-pos))
		(split-pos (if (> left-distance right-distance)
			       right-dot-pos
			       left-dot-pos))
		(left (substring name 0 split-pos))
		(right (substring name split-pos)))
	   (markup
	     #:pad-to-box '(0 . 36) '(-2 . 2) #:column (#:typewriter left
							#:typewriter #:concat ("  " right))
	     #:pad-to-box '(-2 . 4) '(-3.5 . 3.5) #:huge #:musicglyph name))
	 (markup
	   #:pad-to-box '(0 . 36) '(-2 . 2) #:typewriter name
	   #:pad-to-box '(-2 . 4) '(-3.5 . 3.5) #:huge #:musicglyph name)))))

#(define-markup-list-command (doc-chars layout props names) (list?)
   (define (min-length lst n)
     "(min	 (length lst) n)"
     (if (or (null? lst) (<= n 0))
	 0
	 (1+ (min-length (cdr lst) (1- n)))))
   (define (doc-chars-aux names acc)
     (let* ((n (min-length names 2))
	    (head (take names n))
	    (tail (drop names n)))
       (if (null? head)
	   (reverse! acc)
	   (doc-chars-aux tail
			 (cons (make-line-markup (map make-doc-char-markup head))
			       acc)))))
   (interpret-markup-list layout props (doc-chars-aux names (list))))
