FasdUAS 1.101.10   ��   ��    k             l     ��  ��    � � a workaround via applescript was necessary because Illustrator was not responding well to extensive javascript commands involving moving items into groups before scaling the combined groups.     � 	 	~   a   w o r k a r o u n d   v i a   a p p l e s c r i p t   w a s   n e c e s s a r y   b e c a u s e   I l l u s t r a t o r   w a s   n o t   r e s p o n d i n g   w e l l   t o   e x t e n s i v e   j a v a s c r i p t   c o m m a n d s   i n v o l v i n g   m o v i n g   i t e m s   i n t o   g r o u p s   b e f o r e   s c a l i n g   t h e   c o m b i n e d   g r o u p s .   
  
 l     ��  ��    ` Z same in character as other createCueSizeStave scripts except that it does not use prompts     �   �   s a m e   i n   c h a r a c t e r   a s   o t h e r   c r e a t e C u e S i z e S t a v e   s c r i p t s   e x c e p t   t h a t   i t   d o e s   n o t   u s e   p r o m p t s      l     ��  ��    � � this script groups together paths touching symbols so that bindings are maintained when the stave is scaled and the stave remains legible     �     t h i s   s c r i p t   g r o u p s   t o g e t h e r   p a t h s   t o u c h i n g   s y m b o l s   s o   t h a t   b i n d i n g s   a r e   m a i n t a i n e d   w h e n   t h e   s t a v e   i s   s c a l e d   a n d   t h e   s t a v e   r e m a i n s   l e g i b l e      l     ��  ��    { u smaller versions of staves are often used in musical scores when they are not intended as the main focus for reading     �   �   s m a l l e r   v e r s i o n s   o f   s t a v e s   a r e   o f t e n   u s e d   i n   m u s i c a l   s c o r e s   w h e n   t h e y   a r e   n o t   i n t e n d e d   a s   t h e   m a i n   f o c u s   f o r   r e a d i n g      l     ��  ��    %  Copyright Ben Wetherfield 2014     �   >   C o p y r i g h t   B e n   W e t h e r f i e l d   2 0 1 4      l     ��������  ��  ��       !   l     "���� " r      # $ # m      % % � & &� # t a r g e t   I l l u s t r a t o r   i f   ( s e l e c t i o n . l e n g t h   ! =   0 )   {  v a r   d o c   =   a p p . a c t i v e D o c u m e n t ;  v a r   s e l e c t i o n   =   d o c . s e l e c t i o n ;   v a r   s c a l e   =   7 0 ;           f o r   ( i   =   0 ;   i   <   d o c . l a y e r s . l e n g t h ;   i + + )   {                  i f   ( d o c . l a y e r s [ i ] . h a s S e l e c t e d A r t w o r k )   {                          v a r   l a y e r   =   d o c . l a y e r s [ i ] ;                          v a r   i t e m s   =   l a y e r . p a t h I t e m s ;                          f o r   ( i   =   0 ;   i   <   i t e m s . l e n g t h ;   i + + )   {                                  i f   ( i t e m s [ i ] . l a y e r . n a m e   ! = =   ' S t a v e ' )   {                                          g r o u p W i t h O v e r l a p p i n g S y m b o l s ( i t e m s [ i ] ,   l a y e r . s y m b o l I t e m s ) ;                                          }                                  }                                           / /   s c a l e   t o p   l e v e l   g r o u p s                          i t e m s   =   l a y e r . g r o u p I t e m s ;                          f o r   ( i   =   0 ;   i   <   i t e m s . l e n g t h ;   i + + )   {                                  v a r   t o p G r o u p   =   f i n d T o p L e v e l G r o u p ( i t e m s [ i ] ) ;                                  i f   ( t o p G r o u p   = =   i t e m s [ i ] )   {                                          t o p G r o u p . r e s i z e ( s c a l e ,   1 0 0 ) ;                                          }                                  }                                                                           / /   s c a l e   s y m b o l   i t e m s   n o t   i n   g r o u p s                          i t e m s   =   l a y e r . s y m b o l I t e m s ;                          f o r   ( i   =   0 ;   i   <   i t e m s . l e n g t h ;   i + + )   {                                  i f   ( i t e m s [ i ] . p a r e n t . t y p e n a m e   ! = =   ' G r o u p I t e m ' )   {                                          i t e m s [ i ] . r e s i z e ( s c a l e ,   1 0 0 ) ;                                          }                                  }                          }                  }          }   e l s e   {          a l e r t ( ' S e l e c t   a   s t a v e   a n d   i t s   c o n t e n t s ' ) ;          }   / /   t a k e s   p a t h   i t e m   a s   a r g u m e n t   ( p l u s   s y m b o l   i t e m s   t o   c h e c k )  f u n c t i o n   g r o u p W i t h O v e r l a p p i n g S y m b o l s ( i t e m ,   c h e c k I t e m s )   {          v a r   i t e m G r o u p ;          i f   ( i t e m . p a r e n t . t y p e n a m e   = = =   ' G r o u p I t e m ' )   {                  i t e m G r o u p   =   i t e m . p a r e n t ;                  }          e l s e   {                  i t e m G r o u p   =   i t e m . p a r e n t . g r o u p I t e m s . a d d ( ) ;                  i t e m . m o v e ( i t e m G r o u p ,   E l e m e n t P l a c e m e n t . P L A C E A T B E G I N N I N G ) ;                  }          i f   ( c h e c k I t e m s . l e n g t h   ! =   0 )   {                  f o r   ( i   =   0 ;   i   <   c h e c k I t e m s . l e n g t h ;   i + + )   {                          v a r   c h e c k I t e m   =   c h e c k I t e m s [ i ] ;                          / /   i f   n o t   a l r e a d y   g r o u p e d   t o g e t h e r   ( o r   s a m e   i t e m )   c h e c k   f o r   c o l l i s i o n                          i f   ( c h e c k I t e m . p a r e n t   ! =   i t e m G r o u p )   {                                  i f   (   ( ( i t e m . v i s i b l e B o u n d s [ 0 ]   < =   c h e c k I t e m . v i s i b l e B o u n d s [ 2 ] )   / /   i t e m . l e f t   < =   c h e c k I t e m . r i g h t                                          & &   ( i t e m . v i s i b l e B o u n d s [ 1 ]   > =   c h e c k I t e m . v i s i b l e B o u n d s [ 3 ] )   / /   i t e m . t o p   > =   c h e c k I t e m . b o t t o m                                          & &   ( i t e m . v i s i b l e B o u n d s [ 2 ]   > =   c h e c k I t e m . v i s i b l e B o u n d s [ 0 ] )   / / i t e m . r i g h t   > =   c h e c k I t e m . l e f t                                          & &   ( i t e m . v i s i b l e B o u n d s [ 3 ]   < =   c h e c k I t e m . v i s i b l e B o u n d s [ 1 ] ) )   / /   i t e m . b o t t o m   < =   c h e c k I t e m . t o p                                          | |                                          ( ( c h e c k I t e m . v i s i b l e B o u n d s [ 0 ]   < =   i t e m . v i s i b l e B o u n d s [ 2 ] )   / /   c h e c k I t e m . l e f t   < =   i t e m . r i g h t                                          & &   ( c h e c k I t e m . v i s i b l e B o u n d s [ 1 ]   > =   i t e m . v i s i b l e B o u n d s [ 3 ] )   / /   c h e c k I t e m . t o p   > =   i t e m . b o t t o m                                          & &   ( c h e c k I t e m . v i s i b l e B o u n d s [ 2 ]   > =   i t e m . v i s i b l e B o u n d s [ 0 ] )   / / c h e c k I t e m . r i g h t   > =   i t e m . l e f t                                          & &   ( c h e c k I t e m . v i s i b l e B o u n d s [ 3 ]   < =   i t e m . v i s i b l e B o u n d s [ 1 ] ) )   )   / /   c h e c k I t e m . b o t t o m   < =   i t e m . t o p                                          {                                                  c h e c k I t e m . m o v e ( i t e m G r o u p ,   E l e m e n t P l a c e m e n t . P L A C E A T E N D ) ;                                                  }                                          }                                  }                          }                  i f   ( i t e m . p a r e n t . p a g e I t e m s . l e n g t h   = =   1 )   {                          i t e m . m o v e ( i t e m . l a y e r ,   E l e m e n t P l a c e m e n t . P L A C E A T E N D ) ;                          }          }   f u n c t i o n   f i n d T o p L e v e l G r o u p ( c h e c k I t e m )   {          i f   ( c h e c k I t e m . p a r e n t . t y p e n a m e   ! = =   ' G r o u p I t e m ' )   {                  r e t u r n   c h e c k I t e m ;                  }          e l s e   {                  r e t u r n   f i n d T o p L e v e l G r o u p ( c h e c k I t e m . p a r e n t ) ;                  }          }   / /   T a k e s   a   g r o u p   i t e m   a s   a n   a r g u m e n t  f u n c t i o n   m o v e G r o u p C o n t e n t s ( f r o m H e r e ,   m o v e H e r e )   {          f o r   ( i   =   0 ;   i   <   f r o m H e r e . l e n g t h ;   i + + )   {                  i f   ( f r o m H e r e [ i ] . t y p e n a m e   = =   ' G r o u p I t e m ' )   {                          m o v e G r o u p C o n t e n t s ( f r o m H e r e [ i ] ,   m o v e H e r e )                          }                  e l s e   {                          f r o m H e r e [ i ] . m o v e ( m o v e H e r e ,   E l e m e n t P l a c e m e n t . P L A C E A T B E G I N N I N G ) ;                          }                  }          }  $ o      ���� 0 js  ��  ��   !  ' ( ' l     ��������  ��  ��   (  )�� ) l    *���� * O     + , + k     - -  . / . I   �� 0��
�� .miscDjxMutxt       **** 0 o    	���� 0 js  ��   /  1�� 1 I   �� 2 3
�� .miscdoscnull���    utxt 2 m     4 4 � 5 5  S c a l e   S t a v e   7 0 3 �� 6��
�� 
from 6 m     7 7 � 8 8  D e f a u l t   A c t i o n s��  ��   , m     9 9                                                                                  ART5  alis    �  Macintosh HD               �dҚH+   }�Adobe Illustrator.app                                           }�Ёo�        ����  	                Adobe Illustrator CC 2014     �e
�      Ё�     }� I��  KMacintosh HD:Applications: Adobe Illustrator CC 2014: Adobe Illustrator.app   ,  A d o b e   I l l u s t r a t o r . a p p    M a c i n t o s h   H D  <Applications/Adobe Illustrator CC 2014/Adobe Illustrator.app  / ��  ��  ��  ��       �� : ;��   : ��
�� .aevtoappnull  �   � **** ; �� <���� = >��
�� .aevtoappnull  �   � **** < k      ? ?    @ @  )����  ��  ��   =   >  %�� 9�� 4�� 7���� 0 js  
�� .miscDjxMutxt       ****
�� 
from
�� .miscdoscnull���    utxt�� �E�O� �j O���l Uascr  ��ޭ