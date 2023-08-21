-- D:\\Projetos\tcc\v4\src\Magic\Engine\Types\Object.hs:106:1-23: Splicing declarations
baseCardObj ::
  Optics.Iso.Iso' Magic.Engine.Types.Object.CardObject Magic.Engine.Types.Object.Object
baseCardObj
  = (Optics.Iso.iso
       (\ (Magic.Engine.Types.Object.MkCardObject x_a8xF) -> x_a8xF))
      Magic.Engine.Types.Object.MkCardObject
{-# INLINE baseCardObj #-}
-- D:\\Projetos\tcc\v4\src\Magic\Engine\Types\Object.hs:107:1-28: Splicing declarations
basePermObj ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.PermanentObject Magic.Engine.Types.Object.Object
basePermObj
  = Optics.Lens.lensVL
      (\ f_a8yI s_a8yJ
         -> case s_a8yJ of
              Magic.Engine.Types.Object.MkPermanentObject x1_a8yK x2_a8yL x3_a8yM
                -> (GHC.Base.fmap
                      (\ y_a8yN
                         -> ((Magic.Engine.Types.Object.MkPermanentObject y_a8yN) x2_a8yL)
                              x3_a8yM))
                     (f_a8yI x1_a8yK))
{-# INLINE basePermObj #-}
originalPermObj ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.PermanentObject Magic.Engine.Types.Object.Object
originalPermObj
  = Optics.Lens.lensVL
      (\ f_a8yO s_a8yP
         -> case s_a8yP of
              Magic.Engine.Types.Object.MkPermanentObject x1_a8yQ x2_a8yR x3_a8yS
                -> (GHC.Base.fmap
                      (\ y_a8yT
                         -> ((Magic.Engine.Types.Object.MkPermanentObject x1_a8yQ) y_a8yT)
                              x3_a8yS))
                     (f_a8yO x2_a8yR))
{-# INLINE originalPermObj #-}
permanent ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.PermanentObject Magic.Engine.Types.Object.Permanent
permanent
  = Optics.Lens.lensVL
      (\ f_a8yU s_a8yV
         -> case s_a8yV of
              Magic.Engine.Types.Object.MkPermanentObject x1_a8yW x2_a8yX x3_a8yY
                -> (GHC.Base.fmap
                      (\ y_a8yZ
                         -> ((Magic.Engine.Types.Object.MkPermanentObject x1_a8yW) x2_a8yX)
                              y_a8yZ))
                     (f_a8yU x3_a8yY))
{-# INLINE permanent #-}
-- D:\\Projetos\tcc\v4\src\Magic\Engine\Types\Object.hs:108:1-24: Splicing declarations
baseStackObj ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.StackObject Magic.Engine.Types.Object.Object
baseStackObj
  = Optics.Lens.lensVL
      (\ f_a8Am s_a8An
         -> case s_a8An of
              Magic.Engine.Types.Object.MkStackObject x1_a8Ao x2_a8Ap x3_a8Aq
                -> (GHC.Base.fmap
                      (\ y_a8Ar
                         -> ((Magic.Engine.Types.Object.MkStackObject y_a8Ar) x2_a8Ap)
                              x3_a8Aq))
                     (f_a8Am x1_a8Ao))
{-# INLINE baseStackObj #-}
originalStackObj ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.StackObject Magic.Engine.Types.Object.Object
originalStackObj
  = Optics.Lens.lensVL
      (\ f_a8As s_a8At
         -> case s_a8At of
              Magic.Engine.Types.Object.MkStackObject x1_a8Au x2_a8Av x3_a8Aw
                -> (GHC.Base.fmap
                      (\ y_a8Ax
                         -> ((Magic.Engine.Types.Object.MkStackObject x1_a8Au) y_a8Ax)
                              x3_a8Aw))
                     (f_a8As x2_a8Av))
{-# INLINE originalStackObj #-}
stackItem ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.StackObject Magic.Engine.Types.Object.StackItem
stackItem
  = Optics.Lens.lensVL
      (\ f_a8Ay s_a8Az
         -> case s_a8Az of
              Magic.Engine.Types.Object.MkStackObject x1_a8AA x2_a8AB x3_a8AC
                -> (GHC.Base.fmap
                      (\ y_a8AD
                         -> ((Magic.Engine.Types.Object.MkStackObject x1_a8AA) x2_a8AB)
                              y_a8AD))
                     (f_a8Ay x3_a8AC))
{-# INLINE stackItem #-}
-- D:\\Projetos\tcc\v4\src\Magic\Engine\Types\Object.hs:110:1-19: Splicing declarations
activatedAbilities ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Object [Magic.Engine.Types.Ability.Ability]
activatedAbilities
  = Optics.Lens.lensVL
      (\ f_a8C0 s_a8C1
         -> case s_a8C1 of
              Magic.Engine.Types.Object.MkObject x1_a8C2 x2_a8C3 x3_a8C4 x4_a8C5
                                                 x5_a8C6 x6_a8C7 x7_a8C8 x8_a8C9
                -> (GHC.Base.fmap
                      (\ y_a8Ca
                         -> (((((((Magic.Engine.Types.Object.MkObject x1_a8C2) x2_a8C3)
                                   x3_a8C4)
                                  x4_a8C5)
                                 x5_a8C6)
                                x6_a8C7)
                               x7_a8C8)
                              y_a8Ca))
                     (f_a8C0 x8_a8C9))
{-# INLINE activatedAbilities #-}
colors ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Object Magic.Engine.Types.Color.ColorSet
colors
  = Optics.Lens.lensVL
      (\ f_a8Cb s_a8Cc
         -> case s_a8Cc of
              Magic.Engine.Types.Object.MkObject x1_a8Cd x2_a8Ce x3_a8Cf x4_a8Cg
                                                 x5_a8Ch x6_a8Ci x7_a8Cj x8_a8Ck
                -> (GHC.Base.fmap
                      (\ y_a8Cl
                         -> (((((((Magic.Engine.Types.Object.MkObject x1_a8Cd) x2_a8Ce)
                                   x3_a8Cf)
                                  x4_a8Cg)
                                 y_a8Cl)
                                x6_a8Ci)
                               x7_a8Cj)
                              x8_a8Ck))
                     (f_a8Cb x5_a8Ch))
{-# INLINE colors #-}
controller ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Object (GHC.Maybe.Maybe Magic.Engine.Types.Player.PlayerRef)
controller
  = Optics.Lens.lensVL
      (\ f_a8Cm s_a8Cn
         -> case s_a8Cn of
              Magic.Engine.Types.Object.MkObject x1_a8Co x2_a8Cp x3_a8Cq x4_a8Cr
                                                 x5_a8Cs x6_a8Ct x7_a8Cu x8_a8Cv
                -> (GHC.Base.fmap
                      (\ y_a8Cw
                         -> (((((((Magic.Engine.Types.Object.MkObject x1_a8Co) x2_a8Cp)
                                   y_a8Cw)
                                  x4_a8Cr)
                                 x5_a8Cs)
                                x6_a8Ct)
                               x7_a8Cu)
                              x8_a8Cv))
                     (f_a8Cm x3_a8Cq))
{-# INLINE controller #-}
name ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Object GHC.Base.String
name
  = Optics.Lens.lensVL
      (\ f_a8Cx s_a8Cy
         -> case s_a8Cy of
              Magic.Engine.Types.Object.MkObject x1_a8Cz x2_a8CA x3_a8CB x4_a8CC
                                                 x5_a8CD x6_a8CE x7_a8CF x8_a8CG
                -> (GHC.Base.fmap
                      (\ y_a8CH
                         -> (((((((Magic.Engine.Types.Object.MkObject y_a8CH) x2_a8CA)
                                   x3_a8CB)
                                  x4_a8CC)
                                 x5_a8CD)
                                x6_a8CE)
                               x7_a8CF)
                              x8_a8CG))
                     (f_a8Cx x1_a8Cz))
{-# INLINE name #-}
owner ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Object (GHC.Maybe.Maybe Magic.Engine.Types.Player.PlayerRef)
owner
  = Optics.Lens.lensVL
      (\ f_a8CI s_a8CJ
         -> case s_a8CJ of
              Magic.Engine.Types.Object.MkObject x1_a8CK x2_a8CL x3_a8CM x4_a8CN
                                                 x5_a8CO x6_a8CP x7_a8CQ x8_a8CR
                -> (GHC.Base.fmap
                      (\ y_a8CS
                         -> (((((((Magic.Engine.Types.Object.MkObject x1_a8CK) y_a8CS)
                                   x3_a8CM)
                                  x4_a8CN)
                                 x5_a8CO)
                                x6_a8CP)
                               x7_a8CQ)
                              x8_a8CR))
                     (f_a8CI x2_a8CL))
{-# INLINE owner #-}
playAbility ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Object (GHC.Maybe.Maybe Magic.Engine.Types.Ability.Activation)
playAbility
  = Optics.Lens.lensVL
      (\ f_a8CT s_a8CU
         -> case s_a8CU of
              Magic.Engine.Types.Object.MkObject x1_a8CV x2_a8CW x3_a8CX x4_a8CY
                                                 x5_a8CZ x6_a8D0 x7_a8D1 x8_a8D2
                -> (GHC.Base.fmap
                      (\ y_a8D3
                         -> (((((((Magic.Engine.Types.Object.MkObject x1_a8CV) x2_a8CW)
                                   x3_a8CX)
                                  x4_a8CY)
                                 x5_a8CZ)
                                x6_a8D0)
                               y_a8D3)
                              x8_a8D2))
                     (f_a8CT x7_a8D1))
{-# INLINE playAbility #-}
powerToughness ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Object Magic.Engine.Types.Object.PowerToughness
powerToughness
  = Optics.Lens.lensVL
      (\ f_a8D4 s_a8D5
         -> case s_a8D5 of
              Magic.Engine.Types.Object.MkObject x1_a8D6 x2_a8D7 x3_a8D8 x4_a8D9
                                                 x5_a8Da x6_a8Db x7_a8Dc x8_a8Dd
                -> (GHC.Base.fmap
                      (\ y_a8De
                         -> (((((((Magic.Engine.Types.Object.MkObject x1_a8D6) x2_a8D7)
                                   x3_a8D8)
                                  x4_a8D9)
                                 x5_a8Da)
                                y_a8De)
                               x7_a8Dc)
                              x8_a8Dd))
                     (f_a8D4 x6_a8Db))
{-# INLINE powerToughness #-}
types ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Object Magic.Engine.Types.CardType.CardTypeSet
types
  = Optics.Lens.lensVL
      (\ f_a8Df s_a8Dg
         -> case s_a8Dg of
              Magic.Engine.Types.Object.MkObject x1_a8Dh x2_a8Di x3_a8Dj x4_a8Dk
                                                 x5_a8Dl x6_a8Dm x7_a8Dn x8_a8Do
                -> (GHC.Base.fmap
                      (\ y_a8Dp
                         -> (((((((Magic.Engine.Types.Object.MkObject x1_a8Dh) x2_a8Di)
                                   x3_a8Dj)
                                  y_a8Dp)
                                 x5_a8Dl)
                                x6_a8Dm)
                               x7_a8Dn)
                              x8_a8Do))
                     (f_a8Df x4_a8Dk))
{-# INLINE types #-}
-- D:\\Projetos\tcc\v4\src\Magic\Engine\Types\Object.hs:111:1-22: Splicing declarations
damage ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Permanent GHC.Num.Integer.Integer
damage
  = Optics.Lens.lensVL
      (\ f_a8Hr s_a8Hs
         -> case s_a8Hs of
              Magic.Engine.Types.Object.MkPermanent x1_a8Ht x2_a8Hu
                -> (GHC.Base.fmap
                      (\ y_a8Hv
                         -> (Magic.Engine.Types.Object.MkPermanent x1_a8Ht) y_a8Hv))
                     (f_a8Hr x2_a8Hu))
{-# INLINE damage #-}
permanentStatus ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Permanent Magic.Engine.Types.Object.PermanentStatus
permanentStatus
  = Optics.Lens.lensVL
      (\ f_a8Hw s_a8Hx
         -> case s_a8Hx of
              Magic.Engine.Types.Object.MkPermanent x1_a8Hy x2_a8Hz
                -> (GHC.Base.fmap
                      (\ y_a8HA
                         -> (Magic.Engine.Types.Object.MkPermanent y_a8HA) x2_a8Hz))
                     (f_a8Hw x1_a8Hy))
{-# INLINE permanentStatus #-}
-- D:\\Projetos\tcc\v4\src\Magic\Engine\Types\Object.hs:112:1-22: Splicing declarations
stackAttr :: Optics.Iso.Iso' Magic.Engine.Types.Object.StackItem ()
stackAttr
  = (Optics.Iso.iso
       (\ (Magic.Engine.Types.Object.MkStackItem x_a8Iw) -> x_a8Iw))
      Magic.Engine.Types.Object.MkStackItem
{-# INLINE stackAttr #-}
-- D:\\Projetos\tcc\v4\src\Magic\Engine\Types\Object.hs:113:1-28: Splicing declarations
faceStatus ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.PermanentStatus Magic.Engine.Types.Object.FaceStatus
faceStatus
  = Optics.Lens.lensVL
      (\ f_a8IT s_a8IU
         -> case s_a8IU of
              Magic.Engine.Types.Object.PermanentStatus x1_a8IV x2_a8IW x3_a8IX
                                                        x4_a8IY
                -> (GHC.Base.fmap
                      (\ y_a8IZ
                         -> (((Magic.Engine.Types.Object.PermanentStatus x1_a8IV) x2_a8IW)
                               y_a8IZ)
                              x4_a8IY))
                     (f_a8IT x3_a8IX))
{-# INLINE faceStatus #-}
flipStatus ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.PermanentStatus Magic.Engine.Types.Object.FlipStatus
flipStatus
  = Optics.Lens.lensVL
      (\ f_a8J0 s_a8J1
         -> case s_a8J1 of
              Magic.Engine.Types.Object.PermanentStatus x1_a8J2 x2_a8J3 x3_a8J4
                                                        x4_a8J5
                -> (GHC.Base.fmap
                      (\ y_a8J6
                         -> (((Magic.Engine.Types.Object.PermanentStatus x1_a8J2) y_a8J6)
                               x3_a8J4)
                              x4_a8J5))
                     (f_a8J0 x2_a8J3))
{-# INLINE flipStatus #-}
phaseStatus ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.PermanentStatus Magic.Engine.Types.Object.PhaseStatus
phaseStatus
  = Optics.Lens.lensVL
      (\ f_a8J7 s_a8J8
         -> case s_a8J8 of
              Magic.Engine.Types.Object.PermanentStatus x1_a8J9 x2_a8Ja x3_a8Jb
                                                        x4_a8Jc
                -> (GHC.Base.fmap
                      (\ y_a8Jd
                         -> (((Magic.Engine.Types.Object.PermanentStatus x1_a8J9) x2_a8Ja)
                               x3_a8Jb)
                              y_a8Jd))
                     (f_a8J7 x4_a8Jc))
{-# INLINE phaseStatus #-}
tapStatus ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.PermanentStatus Magic.Engine.Types.Object.TapStatus
tapStatus
  = Optics.Lens.lensVL
      (\ f_a8Je s_a8Jf
         -> case s_a8Jf of
              Magic.Engine.Types.Object.PermanentStatus x1_a8Jg x2_a8Jh x3_a8Ji
                                                        x4_a8Jj
                -> (GHC.Base.fmap
                      (\ y_a8Jk
                         -> (((Magic.Engine.Types.Object.PermanentStatus y_a8Jk) x2_a8Jh)
                               x3_a8Ji)
                              x4_a8Jj))
                     (f_a8Je x1_a8Jg))
{-# INLINE tapStatus #-}
-- D:\\Projetos\tcc\v4\src\Magic\Engine\Types\Object.hs:106:1-23: Splicing declarations
baseCardObj ::
  Optics.Iso.Iso' Magic.Engine.Types.Object.CardObject Magic.Engine.Types.Object.Object
baseCardObj
  = (Optics.Iso.iso
       (\ (Magic.Engine.Types.Object.MkCardObject x_a9fZ) -> x_a9fZ))
      Magic.Engine.Types.Object.MkCardObject
{-# INLINE baseCardObj #-}
-- D:\\Projetos\tcc\v4\src\Magic\Engine\Types\Object.hs:107:1-28: Splicing declarations
basePermObj ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.PermanentObject Magic.Engine.Types.Object.Object
basePermObj
  = Optics.Lens.lensVL
      (\ f_a9gl s_a9gm
         -> case s_a9gm of
              Magic.Engine.Types.Object.MkPermanentObject x1_a9gn x2_a9go x3_a9gp
                -> (GHC.Base.fmap
                      (\ y_a9gq
                         -> ((Magic.Engine.Types.Object.MkPermanentObject y_a9gq) x2_a9go)
                              x3_a9gp))
                     (f_a9gl x1_a9gn))
{-# INLINE basePermObj #-}
originalPermObj ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.PermanentObject Magic.Engine.Types.Object.Object
originalPermObj
  = Optics.Lens.lensVL
      (\ f_a9gr s_a9gs
         -> case s_a9gs of
              Magic.Engine.Types.Object.MkPermanentObject x1_a9gt x2_a9gu x3_a9gv
                -> (GHC.Base.fmap
                      (\ y_a9gw
                         -> ((Magic.Engine.Types.Object.MkPermanentObject x1_a9gt) y_a9gw)
                              x3_a9gv))
                     (f_a9gr x2_a9gu))
{-# INLINE originalPermObj #-}
permanent ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.PermanentObject Magic.Engine.Types.Object.Permanent
permanent
  = Optics.Lens.lensVL
      (\ f_a9gx s_a9gy
         -> case s_a9gy of
              Magic.Engine.Types.Object.MkPermanentObject x1_a9gz x2_a9gA x3_a9gB
                -> (GHC.Base.fmap
                      (\ y_a9gC
                         -> ((Magic.Engine.Types.Object.MkPermanentObject x1_a9gz) x2_a9gA)
                              y_a9gC))
                     (f_a9gx x3_a9gB))
{-# INLINE permanent #-}
-- D:\\Projetos\tcc\v4\src\Magic\Engine\Types\Object.hs:108:1-24: Splicing declarations
baseStackObj ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.StackObject Magic.Engine.Types.Object.Object
baseStackObj
  = Optics.Lens.lensVL
      (\ f_a9hW s_a9hX
         -> case s_a9hX of
              Magic.Engine.Types.Object.MkStackObject x1_a9hY x2_a9hZ x3_a9i0
                -> (GHC.Base.fmap
                      (\ y_a9i1
                         -> ((Magic.Engine.Types.Object.MkStackObject y_a9i1) x2_a9hZ)
                              x3_a9i0))
                     (f_a9hW x1_a9hY))
{-# INLINE baseStackObj #-}
originalStackObj ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.StackObject Magic.Engine.Types.Object.Object
originalStackObj
  = Optics.Lens.lensVL
      (\ f_a9i2 s_a9i3
         -> case s_a9i3 of
              Magic.Engine.Types.Object.MkStackObject x1_a9i4 x2_a9i5 x3_a9i6
                -> (GHC.Base.fmap
                      (\ y_a9i7
                         -> ((Magic.Engine.Types.Object.MkStackObject x1_a9i4) y_a9i7)
                              x3_a9i6))
                     (f_a9i2 x2_a9i5))
{-# INLINE originalStackObj #-}
stackItem ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.StackObject Magic.Engine.Types.Object.StackItem
stackItem
  = Optics.Lens.lensVL
      (\ f_a9i8 s_a9i9
         -> case s_a9i9 of
              Magic.Engine.Types.Object.MkStackObject x1_a9ia x2_a9ib x3_a9ic
                -> (GHC.Base.fmap
                      (\ y_a9id
                         -> ((Magic.Engine.Types.Object.MkStackObject x1_a9ia) x2_a9ib)
                              y_a9id))
                     (f_a9i8 x3_a9ic))
{-# INLINE stackItem #-}
-- D:\\Projetos\tcc\v4\src\Magic\Engine\Types\Object.hs:110:1-19: Splicing declarations
activatedAbilities ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Object [Magic.Engine.Types.Ability.Ability]
activatedAbilities
  = Optics.Lens.lensVL
      (\ f_a9jx s_a9jy
         -> case s_a9jy of
              Magic.Engine.Types.Object.MkObject x1_a9jz x2_a9jA x3_a9jB x4_a9jC
                                                 x5_a9jD x6_a9jE x7_a9jF x8_a9jG
                -> (GHC.Base.fmap
                      (\ y_a9jH
                         -> (((((((Magic.Engine.Types.Object.MkObject x1_a9jz) x2_a9jA)
                                   x3_a9jB)
                                  x4_a9jC)
                                 x5_a9jD)
                                x6_a9jE)
                               x7_a9jF)
                              y_a9jH))
                     (f_a9jx x8_a9jG))
{-# INLINE activatedAbilities #-}
colors ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Object Magic.Engine.Types.Color.ColorSet
colors
  = Optics.Lens.lensVL
      (\ f_a9jI s_a9jJ
         -> case s_a9jJ of
              Magic.Engine.Types.Object.MkObject x1_a9jK x2_a9jL x3_a9jM x4_a9jN
                                                 x5_a9jO x6_a9jP x7_a9jQ x8_a9jR
                -> (GHC.Base.fmap
                      (\ y_a9jS
                         -> (((((((Magic.Engine.Types.Object.MkObject x1_a9jK) x2_a9jL)
                                   x3_a9jM)
                                  x4_a9jN)
                                 y_a9jS)
                                x6_a9jP)
                               x7_a9jQ)
                              x8_a9jR))
                     (f_a9jI x5_a9jO))
{-# INLINE colors #-}
controller ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Object (GHC.Maybe.Maybe Magic.Engine.Types.Player.PlayerRef)
controller
  = Optics.Lens.lensVL
      (\ f_a9jT s_a9jU
         -> case s_a9jU of
              Magic.Engine.Types.Object.MkObject x1_a9jV x2_a9jW x3_a9jX x4_a9jY
                                                 x5_a9jZ x6_a9k0 x7_a9k1 x8_a9k2
                -> (GHC.Base.fmap
                      (\ y_a9k3
                         -> (((((((Magic.Engine.Types.Object.MkObject x1_a9jV) x2_a9jW)
                                   y_a9k3)
                                  x4_a9jY)
                                 x5_a9jZ)
                                x6_a9k0)
                               x7_a9k1)
                              x8_a9k2))
                     (f_a9jT x3_a9jX))
{-# INLINE controller #-}
name ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Object GHC.Base.String
name
  = Optics.Lens.lensVL
      (\ f_a9k4 s_a9k5
         -> case s_a9k5 of
              Magic.Engine.Types.Object.MkObject x1_a9k6 x2_a9k7 x3_a9k8 x4_a9k9
                                                 x5_a9ka x6_a9kb x7_a9kc x8_a9kd
                -> (GHC.Base.fmap
                      (\ y_a9ke
                         -> (((((((Magic.Engine.Types.Object.MkObject y_a9ke) x2_a9k7)
                                   x3_a9k8)
                                  x4_a9k9)
                                 x5_a9ka)
                                x6_a9kb)
                               x7_a9kc)
                              x8_a9kd))
                     (f_a9k4 x1_a9k6))
{-# INLINE name #-}
owner ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Object (GHC.Maybe.Maybe Magic.Engine.Types.Player.PlayerRef)
owner
  = Optics.Lens.lensVL
      (\ f_a9kf s_a9kg
         -> case s_a9kg of
              Magic.Engine.Types.Object.MkObject x1_a9kh x2_a9ki x3_a9kj x4_a9kk
                                                 x5_a9kl x6_a9km x7_a9kn x8_a9ko
                -> (GHC.Base.fmap
                      (\ y_a9kp
                         -> (((((((Magic.Engine.Types.Object.MkObject x1_a9kh) y_a9kp)
                                   x3_a9kj)
                                  x4_a9kk)
                                 x5_a9kl)
                                x6_a9km)
                               x7_a9kn)
                              x8_a9ko))
                     (f_a9kf x2_a9ki))
{-# INLINE owner #-}
playAbility ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Object (GHC.Maybe.Maybe Magic.Engine.Types.Ability.Activation)
playAbility
  = Optics.Lens.lensVL
      (\ f_a9kq s_a9kr
         -> case s_a9kr of
              Magic.Engine.Types.Object.MkObject x1_a9ks x2_a9kt x3_a9ku x4_a9kv
                                                 x5_a9kw x6_a9kx x7_a9ky x8_a9kz
                -> (GHC.Base.fmap
                      (\ y_a9kA
                         -> (((((((Magic.Engine.Types.Object.MkObject x1_a9ks) x2_a9kt)
                                   x3_a9ku)
                                  x4_a9kv)
                                 x5_a9kw)
                                x6_a9kx)
                               y_a9kA)
                              x8_a9kz))
                     (f_a9kq x7_a9ky))
{-# INLINE playAbility #-}
powerToughness ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Object Magic.Engine.Types.Object.PowerToughness
powerToughness
  = Optics.Lens.lensVL
      (\ f_a9kB s_a9kC
         -> case s_a9kC of
              Magic.Engine.Types.Object.MkObject x1_a9kD x2_a9kE x3_a9kF x4_a9kG
                                                 x5_a9kH x6_a9kI x7_a9kJ x8_a9kK
                -> (GHC.Base.fmap
                      (\ y_a9kL
                         -> (((((((Magic.Engine.Types.Object.MkObject x1_a9kD) x2_a9kE)
                                   x3_a9kF)
                                  x4_a9kG)
                                 x5_a9kH)
                                y_a9kL)
                               x7_a9kJ)
                              x8_a9kK))
                     (f_a9kB x6_a9kI))
{-# INLINE powerToughness #-}
types ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Object Magic.Engine.Types.CardType.CardTypeSet
types
  = Optics.Lens.lensVL
      (\ f_a9kM s_a9kN
         -> case s_a9kN of
              Magic.Engine.Types.Object.MkObject x1_a9kO x2_a9kP x3_a9kQ x4_a9kR
                                                 x5_a9kS x6_a9kT x7_a9kU x8_a9kV
                -> (GHC.Base.fmap
                      (\ y_a9kW
                         -> (((((((Magic.Engine.Types.Object.MkObject x1_a9kO) x2_a9kP)
                                   x3_a9kQ)
                                  y_a9kW)
                                 x5_a9kS)
                                x6_a9kT)
                               x7_a9kU)
                              x8_a9kV))
                     (f_a9kM x4_a9kR))
{-# INLINE types #-}
-- D:\\Projetos\tcc\v4\src\Magic\Engine\Types\Object.hs:111:1-22: Splicing declarations
damage ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Permanent GHC.Num.Integer.Integer
damage
  = Optics.Lens.lensVL
      (\ f_a9oQ s_a9oR
         -> case s_a9oR of
              Magic.Engine.Types.Object.MkPermanent x1_a9oS x2_a9oT
                -> (GHC.Base.fmap
                      (\ y_a9oU
                         -> (Magic.Engine.Types.Object.MkPermanent x1_a9oS) y_a9oU))
                     (f_a9oQ x2_a9oT))
{-# INLINE damage #-}
permanentStatus ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.Permanent Magic.Engine.Types.Object.PermanentStatus
permanentStatus
  = Optics.Lens.lensVL
      (\ f_a9oV s_a9oW
         -> case s_a9oW of
              Magic.Engine.Types.Object.MkPermanent x1_a9oX x2_a9oY
                -> (GHC.Base.fmap
                      (\ y_a9oZ
                         -> (Magic.Engine.Types.Object.MkPermanent y_a9oZ) x2_a9oY))
                     (f_a9oV x1_a9oX))
{-# INLINE permanentStatus #-}
-- D:\\Projetos\tcc\v4\src\Magic\Engine\Types\Object.hs:112:1-22: Splicing declarations
stackAttr :: Optics.Iso.Iso' Magic.Engine.Types.Object.StackItem ()
stackAttr
  = (Optics.Iso.iso
       (\ (Magic.Engine.Types.Object.MkStackItem x_a9pT) -> x_a9pT))
      Magic.Engine.Types.Object.MkStackItem
{-# INLINE stackAttr #-}
-- D:\\Projetos\tcc\v4\src\Magic\Engine\Types\Object.hs:113:1-28: Splicing declarations
faceStatus ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.PermanentStatus Magic.Engine.Types.Object.FaceStatus
faceStatus
  = Optics.Lens.lensVL
      (\ f_a9qf s_a9qg
         -> case s_a9qg of
              Magic.Engine.Types.Object.PermanentStatus x1_a9qh x2_a9qi x3_a9qj
                                                        x4_a9qk
                -> (GHC.Base.fmap
                      (\ y_a9ql
                         -> (((Magic.Engine.Types.Object.PermanentStatus x1_a9qh) x2_a9qi)
                               y_a9ql)
                              x4_a9qk))
                     (f_a9qf x3_a9qj))
{-# INLINE faceStatus #-}
flipStatus ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.PermanentStatus Magic.Engine.Types.Object.FlipStatus
flipStatus
  = Optics.Lens.lensVL
      (\ f_a9qm s_a9qn
         -> case s_a9qn of
              Magic.Engine.Types.Object.PermanentStatus x1_a9qo x2_a9qp x3_a9qq
                                                        x4_a9qr
                -> (GHC.Base.fmap
                      (\ y_a9qs
                         -> (((Magic.Engine.Types.Object.PermanentStatus x1_a9qo) y_a9qs)
                               x3_a9qq)
                              x4_a9qr))
                     (f_a9qm x2_a9qp))
{-# INLINE flipStatus #-}
phaseStatus ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.PermanentStatus Magic.Engine.Types.Object.PhaseStatus
phaseStatus
  = Optics.Lens.lensVL
      (\ f_a9qt s_a9qu
         -> case s_a9qu of
              Magic.Engine.Types.Object.PermanentStatus x1_a9qv x2_a9qw x3_a9qx
                                                        x4_a9qy
                -> (GHC.Base.fmap
                      (\ y_a9qz
                         -> (((Magic.Engine.Types.Object.PermanentStatus x1_a9qv) x2_a9qw)
                               x3_a9qx)
                              y_a9qz))
                     (f_a9qt x4_a9qy))
{-# INLINE phaseStatus #-}
tapStatus ::
  Optics.Lens.Lens' Magic.Engine.Types.Object.PermanentStatus Magic.Engine.Types.Object.TapStatus
tapStatus
  = Optics.Lens.lensVL
      (\ f_a9qA s_a9qB
         -> case s_a9qB of
              Magic.Engine.Types.Object.PermanentStatus x1_a9qC x2_a9qD x3_a9qE
                                                        x4_a9qF
                -> (GHC.Base.fmap
                      (\ y_a9qG
                         -> (((Magic.Engine.Types.Object.PermanentStatus y_a9qG) x2_a9qD)
                               x3_a9qE)
                              x4_a9qF))
                     (f_a9qA x1_a9qC))
{-# INLINE tapStatus #-}
