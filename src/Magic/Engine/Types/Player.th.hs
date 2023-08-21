-- D:\\Projetos\tcc\v4\src\Magic\Engine\Types\Player.hs:16:1-19: Splicing declarations
life ::
  Optics.Lens.Lens' Magic.Engine.Types.Player.Player GHC.Num.Integer.Integer
life
  = Optics.Lens.lensVL
      (\ f_a80p s_a80q
         -> case s_a80q of
              Magic.Engine.Types.Player.MkPlayer x1_a80r x2_a80s
                -> (GHC.Base.fmap
                      (\ y_a80t -> (Magic.Engine.Types.Player.MkPlayer y_a80t) x2_a80s))
                     (f_a80p x1_a80r))
{-# INLINE life #-}
manaPool ::
  Optics.Lens.Lens' Magic.Engine.Types.Player.Player Magic.Engine.Types.Mana.ManaPool
manaPool
  = Optics.Lens.lensVL
      (\ f_a80u s_a80v
         -> case s_a80v of
              Magic.Engine.Types.Player.MkPlayer x1_a80w x2_a80x
                -> (GHC.Base.fmap
                      (\ y_a80y -> (Magic.Engine.Types.Player.MkPlayer x1_a80w) y_a80y))
                     (f_a80u x2_a80x))
{-# INLINE manaPool #-}
