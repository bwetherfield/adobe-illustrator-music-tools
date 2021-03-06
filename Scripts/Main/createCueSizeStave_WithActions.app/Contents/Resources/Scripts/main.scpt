FasdUAS 1.101.10   ��   ��    k             l     ��  ��    � � a workaround via applescript was necessary because Illustrator was not responding well to extensive javascript commands involving moving items into groups before scaling the combined groups.     � 	 	~   a   w o r k a r o u n d   v i a   a p p l e s c r i p t   w a s   n e c e s s a r y   b e c a u s e   I l l u s t r a t o r   w a s   n o t   r e s p o n d i n g   w e l l   t o   e x t e n s i v e   j a v a s c r i p t   c o m m a n d s   i n v o l v i n g   m o v i n g   i t e m s   i n t o   g r o u p s   b e f o r e   s c a l i n g   t h e   c o m b i n e d   g r o u p s .   
  
 l     ��  ��    � � user will have to input scale factor twice, the second time in the vertical scale factor portion of the scale dialog box triggered by this applescript file (at end)     �  J   u s e r   w i l l   h a v e   t o   i n p u t   s c a l e   f a c t o r   t w i c e ,   t h e   s e c o n d   t i m e   i n   t h e   v e r t i c a l   s c a l e   f a c t o r   p o r t i o n   o f   t h e   s c a l e   d i a l o g   b o x   t r i g g e r e d   b y   t h i s   a p p l e s c r i p t   f i l e   ( a t   e n d )      l     ��  ��    � � this script groups together paths touching symbols so that bindings are maintained when the stave is scaled and the stave remains legible     �     t h i s   s c r i p t   g r o u p s   t o g e t h e r   p a t h s   t o u c h i n g   s y m b o l s   s o   t h a t   b i n d i n g s   a r e   m a i n t a i n e d   w h e n   t h e   s t a v e   i s   s c a l e d   a n d   t h e   s t a v e   r e m a i n s   l e g i b l e      l     ��  ��    { u smaller versions of staves are often used in musical scores when they are not intended as the main focus for reading     �   �   s m a l l e r   v e r s i o n s   o f   s t a v e s   a r e   o f t e n   u s e d   i n   m u s i c a l   s c o r e s   w h e n   t h e y   a r e   n o t   i n t e n d e d   a s   t h e   m a i n   f o c u s   f o r   r e a d i n g      l     ��  ��    %  Copyright Ben Wetherfield 2014     �   >   C o p y r i g h t   B e n   W e t h e r f i e l d   2 0 1 4      l     ��������  ��  ��       !   l     "���� " r      # $ # m      % % � & &&p # t a r g e t   I l l u s t r a t o r 
 
 v a r   d o c   =   a p p . a c t i v e D o c u m e n t ; 
 v a r   s e l e c t i o n   =   d o c . s e l e c t i o n ; 
 
 i f   ( s e l e c t i o n . l e n g t h   ! =   0 )   { 
         v a r   w i n   =   n e w   W i n d o w   ( ' d i a l o g ' ,   ' S c a l e   p e r c e n t a g e ' ) ; 
 
         v a r   f i l e G r o u p   =   w i n . a d d ( ' g r o u p ' ) ;   / /   t h i s   i s   t h e   g r o u p   o n   t h e   l e f t ,   i t   h o l d s   t h e   F i l e   b u t t o n   a n d   t h e   F o n t   l a b e l   n o t e 
 
         v a r   g r p R i g h t   =   w i n . a d d ( ' g r o u p ' ) ;   / /   g r o u p   o n   t h e   r i g h t ,   t o   h o l d   e v e r y t h i n g   e l s e 
 
         v a r   g r p P a n e l   =   g r p R i g h t . a d d ( ' g r o u p ' ) ;   
         v a r   p a g e s P a n e l   =   g r p P a n e l . a d d ( ' p a n e l ' ,   u n d e f i n e d ,   ' S c a l e   b y . . . ' ) ; 
         v a r   t x t S c a l e   =   p a g e s P a n e l . a d d ( ' e d i t t e x t ' , u n d e f i n e d ,   7 0 ) ;   
         v a r   l b l S c a l e   =   p a g e s P a n e l . a d d ( ' s t a t i c t e x t ' , u n d e f i n e d , ' % ' ) ; 
 
         v a r   b t n G r o u p   =   g r p P a n e l . a d d ( ' g r o u p ' ) ; 
         v a r   b t n O k   =   b t n G r o u p . a d d ( ' b u t t o n ' ,   u n d e f i n e d ,   ' S c a l e ' ) ; 
         v a r   b t n C a n c e l   =   b t n G r o u p . a d d ( ' b u t t o n ' ,   u n d e f i n e d ,   ' C a n c e l ' ) ; 
 
         w i n . o r i e n t a t i o n   =   p a g e s P a n e l . o r i e n t a t i o n   =   ' r o w ' ;   / /   t w o   i t e m s   f i l e G r o u p   a n d   g r p R i g h t 
         w i n . a l i g n C h i l d r e n   =   ' r i g h t ' ; 
         f i l e G r o u p . o r i e n t a t i o n   =   ' c o l u m n ' ; 
         f i l e G r o u p . a l i g n m e n t   =   ' t o p ' ; 
 
         g r p R i g h t . o r i e n t a t i o n   =   ' c o l u m n ' ; 
         b t n G r o u p . o r i e n t a t i o n   =   ' c o l u m n ' ; 
 
         t x t S c a l e . a c t i v e   =   t r u e ; 
 
         t x t S c a l e . c h a r a c t e r s   =   3 ; 
 
         b t n O k . o n C l i c k   =   f u n c t i o n ( ) { 
                 w i n . c l o s e ( ) ;   / /   c l o s e   w h e n   d o n e 
                 } 
 
         w i n . c e n t e r   ( ) ; 
         w i n . s h o w ( ) ; 
 
         v a r   s c a l e   =   t x t S c a l e . t e x t ; 
 
         f o r   ( i   =   0 ;   i   <   d o c . l a y e r s . l e n g t h ;   i + + )   { 
                 i f   ( d o c . l a y e r s [ i ] . h a s S e l e c t e d A r t w o r k )   { 
                         v a r   l a y e r   =   d o c . l a y e r s [ i ] ; 
                         v a r   i t e m s   =   l a y e r . p a t h I t e m s ; 
                         f o r   ( i   =   0 ;   i   <   i t e m s . l e n g t h ;   i + + )   { 
                                 i f   ( i t e m s [ i ] . l a y e r . n a m e   ! = =   ' S t a v e ' )   { 
                                         g r o u p W i t h O v e r l a p p i n g S y m b o l s ( i t e m s [ i ] ,   l a y e r . s y m b o l I t e m s ) ; 
                                         } 
                                 } 
                 
                         / /   s c a l e   t o p   l e v e l   g r o u p s 
                         i t e m s   =   l a y e r . g r o u p I t e m s ; 
                         f o r   ( i   =   0 ;   i   <   i t e m s . l e n g t h ;   i + + )   { 
                                 v a r   t o p G r o u p   =   f i n d T o p L e v e l G r o u p ( i t e m s [ i ] ) ; 
                                 i f   ( t o p G r o u p   = =   i t e m s [ i ] )   { 
                                         t o p G r o u p . r e s i z e ( s c a l e ,   1 0 0 ) ; 
                                         } 
                                 }                         
                         
                         / /   s c a l e   s y m b o l   i t e m s   n o t   i n   g r o u p s 
                         i t e m s   =   l a y e r . s y m b o l I t e m s ; 
                         f o r   ( i   =   0 ;   i   <   i t e m s . l e n g t h ;   i + + )   { 
                                 i f   ( i t e m s [ i ] . p a r e n t . t y p e n a m e   ! = =   ' G r o u p I t e m ' )   { 
                                         i t e m s [ i ] . r e s i z e ( s c a l e ,   1 0 0 ) ; 
                                         } 
                                 } 
                         
                         a l e r t ( ' R e - e n t e r   s c a l e   f a c t o r   i n   v e r t i c a l   s c a l e - f a c t o r   b o x   w h e n   t h e   s c a l e   d i a l o g   b o x   a p p e a r s ' ) ; 
                         } 
                 } 
         } 
 
 e l s e   { 
         a l e r t ( ' S e l e c t   a   s t a v e   a n d   i t s   c o n t e n t s ' ) ; 
         } 
 
 / /   t a k e s   p a t h   i t e m   a s   a r g u m e n t   ( p l u s   s y m b o l   i t e m s   t o   c h e c k ) 
 f u n c t i o n   g r o u p W i t h O v e r l a p p i n g S y m b o l s ( i t e m ,   c h e c k I t e m s )   { 
         v a r   i t e m G r o u p ; 
         i f   ( i t e m . p a r e n t . t y p e n a m e   = = =   ' G r o u p I t e m ' )   { 
                 i t e m G r o u p   =   i t e m . p a r e n t ; 
                 } 
         e l s e   { 
                 i t e m G r o u p   =   i t e m . p a r e n t . g r o u p I t e m s . a d d ( ) ; 
                 i t e m . m o v e ( i t e m G r o u p ,   E l e m e n t P l a c e m e n t . P L A C E A T B E G I N N I N G ) ; 
                 } 
         i f   ( c h e c k I t e m s . l e n g t h   ! =   0 )   { 
                 f o r   ( i   =   0 ;   i   <   c h e c k I t e m s . l e n g t h ;   i + + )   { 
                         v a r   c h e c k I t e m   =   c h e c k I t e m s [ i ] ; 
                         / /   i f   n o t   a l r e a d y   g r o u p e d   t o g e t h e r   ( o r   s a m e   i t e m )   c h e c k   f o r   c o l l i s i o n 
                         i f   ( c h e c k I t e m . p a r e n t   ! =   i t e m G r o u p )   { 
                                 i f   (   ( ( i t e m . v i s i b l e B o u n d s [ 0 ]   < =   c h e c k I t e m . v i s i b l e B o u n d s [ 2 ] )   / /   i t e m . l e f t   < =   c h e c k I t e m . r i g h t 
                                         & &   ( i t e m . v i s i b l e B o u n d s [ 1 ]   > =   c h e c k I t e m . v i s i b l e B o u n d s [ 3 ] )   / /   i t e m . t o p   > =   c h e c k I t e m . b o t t o m 
                                         & &   ( i t e m . v i s i b l e B o u n d s [ 2 ]   > =   c h e c k I t e m . v i s i b l e B o u n d s [ 0 ] )   / / i t e m . r i g h t   > =   c h e c k I t e m . l e f t 
                                         & &   ( i t e m . v i s i b l e B o u n d s [ 3 ]   < =   c h e c k I t e m . v i s i b l e B o u n d s [ 1 ] ) )   / /   i t e m . b o t t o m   < =   c h e c k I t e m . t o p 
                                         | | 
                                         ( ( c h e c k I t e m . v i s i b l e B o u n d s [ 0 ]   < =   i t e m . v i s i b l e B o u n d s [ 2 ] )   / /   c h e c k I t e m . l e f t   < =   i t e m . r i g h t 
                                         & &   ( c h e c k I t e m . v i s i b l e B o u n d s [ 1 ]   > =   i t e m . v i s i b l e B o u n d s [ 3 ] )   / /   c h e c k I t e m . t o p   > =   i t e m . b o t t o m 
                                         & &   ( c h e c k I t e m . v i s i b l e B o u n d s [ 2 ]   > =   i t e m . v i s i b l e B o u n d s [ 0 ] )   / / c h e c k I t e m . r i g h t   > =   i t e m . l e f t 
                                         & &   ( c h e c k I t e m . v i s i b l e B o u n d s [ 3 ]   < =   i t e m . v i s i b l e B o u n d s [ 1 ] ) )   )   / /   c h e c k I t e m . b o t t o m   < =   i t e m . t o p 
                                         { 
                                                 c h e c k I t e m . m o v e ( i t e m G r o u p ,   E l e m e n t P l a c e m e n t . P L A C E A T E N D ) ; 
                                                 } 
                                         } 
                                 } 
                         } 
                 i f   ( i t e m . p a r e n t . p a g e I t e m s . l e n g t h   = =   1 )   { 
                         i t e m . m o v e ( i t e m . l a y e r ,   E l e m e n t P l a c e m e n t . P L A C E A T E N D ) ; 
                         } 
         } 
 
 f u n c t i o n   f i n d T o p L e v e l G r o u p ( c h e c k I t e m )   { 
         i f   ( c h e c k I t e m . p a r e n t . t y p e n a m e   ! = =   ' G r o u p I t e m ' )   { 
                 r e t u r n   c h e c k I t e m ; 
                 } 
         e l s e   { 
                 r e t u r n   f i n d T o p L e v e l G r o u p ( c h e c k I t e m . p a r e n t ) ; 
                 } 
         } 
 
 / /   T a k e s   a   g r o u p   i t e m   a s   a n   a r g u m e n t 
 f u n c t i o n   m o v e G r o u p C o n t e n t s ( f r o m H e r e ,   m o v e H e r e )   { 
         f o r   ( i   =   0 ;   i   <   f r o m H e r e . l e n g t h ;   i + + )   { 
                 i f   ( f r o m H e r e [ i ] . t y p e n a m e   = =   ' G r o u p I t e m ' )   { 
                         m o v e G r o u p C o n t e n t s ( f r o m H e r e [ i ] ,   m o v e H e r e ) 
                         } 
                 e l s e   { 
                         f r o m H e r e [ i ] . m o v e ( m o v e H e r e ,   E l e m e n t P l a c e m e n t . P L A C E A T B E G I N N I N G ) ; 
                         } 
                 } 
         } 
 $ o      ���� 0 js  ��  ��   !  ' ( ' l     ��������  ��  ��   (  )�� ) l    *���� * O     + , + k     - -  . / . I   �� 0��
�� .miscDjxMutxt       **** 0 o    	���� 0 js  ��   /  1�� 1 I   �� 2 3
�� .miscdoscnull���    utxt 2 m     4 4 � 5 5  S c a l e   S t a v e 3 �� 6��
�� 
from 6 m     7 7 � 8 8  D e f a u l t   A c t i o n s��  ��   , m     9 9                                                                                  ART5  alis    �  Macintosh HD               ϣ�$H+   G�Adobe Illustrator.app                                           G��7"�        ����  	                Adobe Illustrator CC 2014     ϣ�d      �7Z�     G�   �  KMacintosh HD:Applications: Adobe Illustrator CC 2014: Adobe Illustrator.app   ,  A d o b e   I l l u s t r a t o r . a p p    M a c i n t o s h   H D  <Applications/Adobe Illustrator CC 2014/Adobe Illustrator.app  / ��  ��  ��  ��       �� : ; %��   : ����
�� .aevtoappnull  �   � ****�� 0 js   ; �� <���� = >��
�� .aevtoappnull  �   � **** < k      ? ?    @ @  )����  ��  ��   =   >  %�� 9�� 4�� 7���� 0 js  
�� .miscDjxMutxt       ****
�� 
from
�� .miscdoscnull���    utxt�� �E�O� �j O���l U ascr  ��ޭ