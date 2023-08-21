-- D:\\Projetos\tcc\v4\src\Magic\Engine\Types\CardType.hs:28:1-24: Splicing declarations
cardTypes ::
  Optics.Lens.Lens' Magic.Engine.Types.CardType.CardTypeSet Magic.Engine.Types.CardType.CardTypes
cardTypes
  = Optics.Lens.lensVL
      (\ f_a780 s_a781
         -> case s_a781 of
              Magic.Engine.Types.CardType.CardTypeSet x1_a782 x2_a783 x3_a784
                -> (GHC.Base.fmap
                      (\ y_a785
                         -> ((Magic.Engine.Types.CardType.CardTypeSet x1_a782) y_a785)
                              x3_a784))
                     (f_a780 x2_a783))
{-# INLINE cardTypes #-}
subTypes ::
  Optics.Lens.Lens' Magic.Engine.Types.CardType.CardTypeSet Magic.Engine.Types.CardType.SubTypes
subTypes
  = Optics.Lens.lensVL
      (\ f_a786 s_a787
         -> case s_a787 of
              Magic.Engine.Types.CardType.CardTypeSet x1_a788 x2_a789 x3_a78a
                -> (GHC.Base.fmap
                      (\ y_a78b
                         -> ((Magic.Engine.Types.CardType.CardTypeSet x1_a788) x2_a789)
                              y_a78b))
                     (f_a786 x3_a78a))
{-# INLINE subTypes #-}
superTypes ::
  Optics.Lens.Lens' Magic.Engine.Types.CardType.CardTypeSet Magic.Engine.Types.CardType.SuperTypes
superTypes
  = Optics.Lens.lensVL
      (\ f_a78c s_a78d
         -> case s_a78d of
              Magic.Engine.Types.CardType.CardTypeSet x1_a78e x2_a78f x3_a78g
                -> (GHC.Base.fmap
                      (\ y_a78h
                         -> ((Magic.Engine.Types.CardType.CardTypeSet y_a78h) x2_a78f)
                              x3_a78g))
                     (f_a78c x1_a78e))
{-# INLINE superTypes #-}
