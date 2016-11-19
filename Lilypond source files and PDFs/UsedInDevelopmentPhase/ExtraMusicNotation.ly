%{

Arbitrary lilypond markup used to generate hairpin mouse icons as PNGs and used to make the stafflines brush (I opened the compiled PDF in Adobe Illustrator highlighted a stave and saved the stafflines as a single brush named "Stafflines" - used to make staves in Illustrator [see scripts])

%}


\relative c'' {
  c4\< c\! c\> c\!
  \override Hairpin.circled-tip = ##t
  c\< c\!
  \override Hairpin.circled-tip = ##f
  c c
  \override Hairpin.stencil = #flared-hairpin
  c\< c\! c\> c\! 
}

\relative c'' {
  \override Hairpin.stencil = #flared-hairpin
  a4\< a a a\f
  a4\p\< a a a\ff
  a4\sfz\< a a a\!
  \override Hairpin.stencil = #constante-hairpin
  a4\< a a a\f
  a4\p\< a a a\ff
  a4\sfz\< a a a\!
  \override Hairpin.stencil = #flared-hairpin
  a4\> a a a\f
  a4\p\> a a a\ff
  a4\sfz\> a a a\!
  \override Hairpin.stencil = #constante-hairpin
  a4\> a a a\f
  a4\p\> a a a\ff
  a4\sfz\> a a a\!
}

\relative c'' {
  \override Hairpin.circled-tip = ##t
  \override Hairpin.minimum-length = #10
  c2\< c\!
  c4\> c2\!
}

glissandoSkipOn = {
  \override NoteColumn.glissando-skip = ##t
  \hide NoteHead
  \override NoteHead.no-ledgers = ##t
}

glissandoSkipOff = {
  \revert NoteColumn.glissando-skip
  \undo \hide NoteHead
  \revert NoteHead.no-ledgers
}


{
f1 \bar "|"
f1 \bar "."
g1 \bar "||"
a1 \bar ".|"
b1 \bar ".."
c1 \bar "|.|"
d1 \bar "|."
}

\new Staff {
  s1 \bar "|"
  s1 \bar "."
  s1 \bar "!"
  s1 \bar ";"
  s1 \bar ":"
  s1 \bar "k"
  s1 \bar "S"
  s1 \bar "="
  s1 \bar "["
  s1 \bar "]"
  s1 \bar ""
}

\version "2.18.2"  % necessary for upgrading to future LilyPond versions.
