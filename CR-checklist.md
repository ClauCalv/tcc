
# Table of Contents <!-- omit in toc -->

- [Points of Interest](#points-of-interest)
- [Status Codes](#status-codes)
- [Comprehensive Rules](#comprehensive-rules)
  - [1: Game Concepts](#1-game-concepts)
    - [100. General](#100-general)
    - [101. The Magic Golden Rules](#101-the-magic-golden-rules)
    - [102. Players](#102-players)
    - [103. Starting the Game](#103-starting-the-game)
    - [104. Ending the Game](#104-ending-the-game)
    - [105. Colors](#105-colors)
    - [106. Mana](#106-mana)
    - [107. Numbers and Symbols](#107-numbers-and-symbols)
    - [108. Cards](#108-cards)
    - [109. Objects](#109-objects)
    - [110. Permanents](#110-permanents)
    - [111. Tokens](#111-tokens)
    - [112. Spells](#112-spells)
    - [113. Abilities](#113-abilities)

# Points of Interest

- Procedures
  - [Starting the game](#poi-game-starting-procedures----omit-in-toc)
- Definitions
  - [Colors](#poi-colors-definitions----omit-in-toc)
  - [Mana](#poi-colors-definitions----omit-in-toc)
  - [Mana Costs](#poi-mana-costs-definitions----omit-in-toc)
  - [Objects](#poi-objects-definitions----omit-in-toc)
  - [Permanents](#poi-permanents-definitions----omit-in-toc)
  - [Spells](#poi-spell-definitions----omit-in-toc)
- Implementation problems
  - [Identifying Mana](#poi-mana-identification-problem----omit-in-toc)

# Status Codes

- :large_blue_circle: : Irrelevant to us
- :purple_circle: : Cant be directly implemented, but instead guides implementation.
- :green_circle: : Implemented
- :yellow_circle: : In progress
- :red_circle: : Needs to be done
- :brown_circle: : Skipped/Postponed
- :black_circle: : Skipped due to variant gameplay.

# Comprehensive Rules

## 1: Game Concepts

### 100. General

**100.1** (:large_blue_circle:) : about two-player vs multiplayer. We treat they the same.

- **100.1a** (:large_blue_circle:) : two is two
- **100.1b** (:large_blue_circle:) : more is more
  
**100.2** (:brown_circle:) : about deck-building. We will run no validations for now. Remember to consider diferent variants.

1. *TODO: check and enforce building rules*

- **100.2a** (:brown_circle:) : constructed decks rules
  1. *TODO: Deck size limit*
  2. *TODO: **Rule of four** (with English names)*
- **100.2b** (:black_circle:) : limited decks rules. Wont be implemented at all.
- **100.2c** (:black_circle:) : Commander decks rules. Wont be implemented for now.

**100.3** (:large_blue_circle:) : about external elements like dice. Not covered.

**100.4** (:brown_circle:) : About sideboard. Wont be implemented.

- **100.4a** (:brown_circle:) : About constructed sideboard. *Rule of Four* shared with main deck.
- **100.4b** (:brown_circle:) : About limited sideboard.
- **100.4c** (:brown_circle:) : About limited sideboard with *Two-Headed Giant* as variant
- **100.4d** (:brown_circle:) : About limited sideboard with other multiplayer variants
  
**100.5** (:brown_circle:) : About minimum and maximum deck size

1. *TODO: Deck size limit*

**100.6** (:brown_circle:) : About tournaments and banned cards.

1. *TODO: Different formats and variants; rules and banned cards*

- **100.6a** (:large_blue_circle:) : A match is usually a best-of-three-games
- **100.6b** (:large_blue_circle:) : There is a site to find tournaments
  
**100.7** (:large_blue_circle:) : About unnoficial or silver-border cards. Wont be covered.

### 101. The Magic Golden Rules

**101.1** :purple_circle: : Cards can override rules

**101.2** :red_circle: : Effects that block things to happen takes precedent over that thing. 

1. *Example: "You cant draw cards" takes precedence over "Draw a card"*.

- **101.2a** :red_circle: : Adding abilities to objects and removing abilities from objects don't fall under this rule.
  
**101.3** :red_circle: : Any part of an instruction that's impossible to perform is ignored. Cards may specify consequences for this.

**101.4** :yellow_circle: : **APNAP Rule**. If multiple players would decide something at the same time, they decide in turn order, starting by the active player.

1. *IN PROGRESS: APNAP Rule*.

- **101.4a** :yellow_circle: : Cards face-down or hidden stay that way, but the choice must be clear.
- **101.4b** :red_circle: : A player knows the choices made by the previous players when making their choice.
- **101.4c** :red_circle: : If a player must make more than one choice at the same time, he may choose the order if it isnt already specified
- **101.4d** :yellow_circle: : If a choice causes at least one different player to make a choice, that choice is made in APNAP order.
- **101.4e** :yellow_circle: : If the game is starting, the starting player is considered the active player for APNAP rule.

### 102. Players

**102.1** :green_circle: : Player is one of the people in game. Active player is the turn owner. 

**102.2** :green_circle: : In a two-player game, the other player is the opponent.

**102.3** :green_circle: : In a multiplayer game, players on your team are teammates, all others are opponents.

**102.4** :green_circle: : "Your team" means "you and/or your teammates". It there is no team, "Your team" is "You".

### 103. Starting the Game

**103.1** :large_blue_circle: : About choosing starting player. First game of a match, players can use any mutually agreeable method. Other games, starting player is last game's loser. On draw, last game's chooser chooses again. Turn order is clockwise.

- **103.1a** :black_circle: : In a game using the shared team turns option, there is a starting team rather than a starting player.
- **103.1b** :black_circle: : In an Archenemy game, the archenemy takes the first turn.
- **103.1c** :large_blue_circle: : One card (*Power Play*) states that its controller is the starting player. This effect overrides all methods.

##### **POI**: GAME STARTING PROCEDURES <!-- omit in toc -->

**103.2** :yellow_circle: : About initial deck-shuffling.

1. *TODO: Implement ordered zones and shuffling*

- **103.2a** :brown_circle: : Set sideboard aside before shuffling.
- **103.2b** :black_circle: : About revealing a Companion.
- **103.2c** :black_circle: : About setting a Commander in its zone.
- **103.2d** :black_circle: : About setting conspiracies in their zone.

**103.3** :yellow_circle: : About starting life total. Defaults to 20.

1. *TODO: Implement different game configs support (even though we're not implementing different variants)*

- **103.3a** :black_circle: : In a *Two-Headed Giant* game, its 30 per team.
- **103.3b** :black_circle: : In a *Vanguard* game, its 20 +- vanguard card modifier
- **103.3c** :black_circle: : In a *Commander* game, its 40.
- **103.3d** :black_circle: : In a two-player *Brawl* game, its 25. In a multiplayer *Brawl* game, its 30.
- **103.3e** :black_circle: : In an *Archenemy* game, its 40 for the archenemy.

**103.4** :red_circle: : Starting hand is default to 7 cards. **MULLIGAN**; about changing opening hand with increasing penalties. Mulligans declarations are in order, but are executed simultaneously.

1. *TODO: Mulligans*

- **103.4a** :black_circle: : In a *Vanguard* game, starting hand size is 20 +- vanguard card modifier.
- **103.4b** :red_circle: : About mulligan-timed actions.
- **103.4c** :brown_circle: : About free mulligans at *Brawl* or multiplayer games.
- **103.4d** :brown_circle: : About mulligans on games using the shared team turns option.

**103.5** :red_circle: : About opening-hand-timed actions.

- **103.5a** :red_circle: : Actions of begginning game with card on battlefield
- **103.5b** :red_circle: : Actions of revealing a card from opening hand.
- **103.5c** :black_circle: : About such actions on games using the shared team turns option.

**103.6** :black_circle: : About setting initial plane on a *Planeschase* game.

**103.7** :red_circle: : About first turn.

- **103.7a** :red_circle: : In a two-player game, the starting player skips the first draw step
  1. *TODO: Skip first player draw*
- **103.7b** :black_circle: : In a *Two-Headed Giant* game, the starting team skips the first draw step
- **103.7c** :green_circle: : In all other multiplayer games, no player skips the first draw step.

### 104. Ending the Game
 
**104.1** :red_circle: : Game ends when a player wins, a draw, or when is restarted.

**104.2** :red_circle: : About winning the game

- **104.2a** :red_circle: : If all other players have left, the player still in game wins. This cannot be overriden.
- **104.2b** :red_circle: : Effect may state that a player wins
- **104.2c** :black_circle: : About winning on games with *teams*.
- **104.2d** :black_circle: : About winning on *Emperor* games.

**104.3** :red_circle: : About losing the game

- **104.3a** :red_circle: : Conceding. Cannot be overriden.
- **104.3b** :red_circle: : *SBA*: Having 0 or less life total
- **104.3c** :red_circle: : Drawing from empty deck, loses on next *SBA-check*.
  1. *IMPORTANT: must be dealt carefully. Create field on player saying he should lose instead of losing right away*
- **104.3d** :red_circle: : *SBA*: Having 10 or more poison counters
- **104.3e** :red_circle: : Effect may state that a player loses
- **104.3f** :red_circle: : If a player would win and lose simultaneously, he loses.
- **104.3g** :black_circle: : About losing on games with *teams*.
- **104.3h** :black_circle: : About losing on games with *range of influence*.
- **104.3i** :black_circle: : About losing on *Emperor* games.
- **104.3j** :black_circle: : About losing on *Commander* games; *SBA*: Have being dealt 21 or more combat damage from the same *commander*.
- **104.3k** :black_circle: : Losing as a penalty applied by a judge in a tournament.

**104.4** :red_circle: : About drawing the game.

- **104.4a** :red_circle: : If all remaining players lose simultaneously, its a draw.
- **104.4b** :brown_circle: : If a infinite *loop of mandatory actions* occurs, the game ends in a draw, unless if on a game with *range of influence*.
  1. *TODO: Create history of recent events (since last priority or decision) in addition to the game history*
  2. *TODO: Create an algorithm to detect **true** infinity loops. It must consider not only the loop, but the entire state of the table. May not be feasible*
- **104.4c** :red_circle: : Effect may state that its a draw.
- **104.4d** :black_circle: : About drawing on games with *teams* caused by losing.
- **104.4e** :black_circle: : About drawing on games with *range of influence* by effects.
- **104.4f** :black_circle: : About drawing on games with *range of influence* by infinite *loop of mandatory actions*.
- **104.4g** :black_circle: : About drawing on games with *teams* caused by drawing directly.
- **104.4h** :black_circle: : About drawing on *Emperor* games.
- **104.4i** :black_circle: : About agreeing to draw on a tournament.

**104.5** :red_circle: : If a player loses or is a draw for him, he leaves the game

1. In a two-player game, it means game over.
2. In a multiplayer game, see rule **800.4** for the process of leaving the game.

**104.6** :brown_circle: : One card (*Karn Liberated*) restarts the game. See rule **719** for restarting.

### 105. Colors

##### **POI**: COLORS DEFINITIONS <!-- omit in toc -->

**105.1** :green_circle: : There are five colors: **W**HITE, BL**U**E, **B**LACK, **R**ED, and **G**REEN.

1. Commonly abreviated and in this specific order: **WUBRG**;

**105.2** :green_circle: : About objects colors.

- **105.2a** :green_circle: Monocolored has exactly one color.
- **105.2b** :green_circle: Multicolored has two or more colors.
- **105.2c** :green_circle: Colorless has no color.

**105.3** :red_circle: : Effects may change the color of an object, either completely or by adding/removing a color.

**105.4** :yellow_circle: :  When choosing a color, chose one of WUBRG. You cannot choose colorless or multicolor.

**105.5** :purple_circle: : Color pair is exactly two colors.

### 106. Mana

##### **POI**: MANA DEFINITIONS <!-- omit in toc -->

**106.1** :green_circle: : About mana

- **106.1a** :green_circle: : There are 5 colors of mana: WUBRG
- **106.1b** :green_circle: : There are 6 types of mana: WUBRG + Colorless

**106.2** :large_blue_circle: : About mana symbols.

**106.3** :red_circle: : About mana generation.

**106.4** :red_circle: About mana pool. It empties at the end of every end of step and phase.

- **106.4a** :large_blue_circle: : Mana not spent after paying cost must be declared.
- **106.4b** :large_blue_circle: : Mana in the pool after priority pass must be declared.

**106.5** :red_circle: : Generating undefined mana generates no mana.

##### **POI**: MANA IDENTIFICATION PROBLEM <!-- omit in toc -->

**106.6** :brown_circle: : Mana can be created restricted or with a trigger when spent. Triggers and effects created this way are created once for each mana.

1. *PROBLEM: How to separate 'normal' mana from mana with requisites/triggers? If a player has two mana on his pool, one triggered and one simple, which is spent first? Can he choose which is spent to trigger/avoid the triggered effect?*

- **106.6a** :brown_circle: : Replacement effects that increases mana produced by a source causes this extra mana follow any restrictions or triggers the other mana by that source would.

**106.7** :brown_circle: Abilities that generate mana that another permanent "could produce", considers if that permanents' mana ability resolved that instant, with all replacements applied, ignoring all costs.

**106.8** :red_circle: : About generating mana from an *hybrid symbol*

**106.9** :red_circle: : About generating mana from a *phyrexian symbol*

**106.10** :red_circle: : About generating mana from an *generic symbol*

**106.11** :red_circle: : About generating mana from an *snow symbol*

**106.12** :purple_circle: : "Tapping for mana" means activating a mana ability with a tap cost.

- **106.12a** :red_circle: : Triggers for "Tapping for mana" triggers when it resolves
- **106.12a** :red_circle: : Replacements for "Tapping for mana" triggers as it resolves

**106.13** :brown_circle: : One card (*Drain Power*) have a player empty his manapool and add that mana to other player's pool. All effects associated remains with that mana.

### 107. Numbers and Symbols

**107.1** :purple_circle: : Magic only use Integral numbers.

- **107.1a** :purple_circle: : Any effect that could generate a fractional number will tell you whether to round up or down.
- **107.1b** :purple_circle: : Some game values can be negative, but players cannot choose negative numbers and calculation with negative results will yield zero.

- **107.1c** :red_circle: : If a player is to choose "any number", that player may choose any positive number or zero.

**107.2** :purple_circle: : If a number cant be determined, it is zero.

**107.3** :red_circle: : X is a placeholder for a number that needs to be determined. X can be defined by an ability or let to be chosen by the player.

- **107.3a** :red_circle: : If a spell/ability has a cost with an not-defined X in it, the controller announces the value of X as he casts/activates it. While a spell/ability is on the stack, any X equals the announced value.
- **107.3b** :red_circle: : If a player is casting a spell that has a not-defined X in its mana cost, and an effect lets that player cast that spell while not paying its mana cost, then the only legal choice for X is 0.
- **107.3c** :red_circle: : If a spell/ability has an X in its cost, and the value of X is defined by the text of that spell/ability, then that's the value of X while that spell/ability is on the stack.
- **107.3d** :red_circle: : If a cost associated with a special action has an X in it, the value of X is chosen by the player immediately before they pay that cost.
- **107.3e** :red_circle: : When not-defined X appears in the text of a spell/ability but not in a cost, the controller chooses the value of X at the appropriate time.
- **107.3f** :red_circle: : X is always 0 outside the stack.
- **107.3g** :red_circle: : In an *object's mana cost* that includes X, X's value is 0 unless the object is a spell on the stack, where the value is whatever was determined as it entered the stack.
- **107.3h** :red_circle: : Normally, all instances of X on an object have the same value at any given time.
- **107.3i** :red_circle: : If an object gains an ability, the value of X within that ability is what the abilitiy defines or zero. This is an exception to **107.3h**.
- **107.3j** :red_circle: : If an object's activated ability has an X in its activation cost, the value of X for that ability is independent of any other values of X chosen for that object or for other instances of abilities of that object. This is an exception to **107.3h**.
- **107.3k** :red_circle: : If a spell with X just resolved to an object with an **ETB** effect that refers to X, that X value is passed to the effect, although the value of X for that permanent is 0. This is an exception to **107.3h**.
- **107.3m** :purple_circle: : Some objects use the letter Y in addition to the letter X. Y follows the same rules as X.

##### **POI**: MANA COSTS DEFINITIONS <!-- omit in toc -->

**107.4** :large_blue_circle: : About the symbols. Irrelevant to back-end.

- **107.4a** :yellow_circle: : The five primary colored mana symbols are used to represent both *colored mana* and *colored mana costs*. Colored mana costs can be paid only with the appropriate color of mana.
- **107.4b** :yellow_circle: : Numerical symbols (1) and variable symbols (X) represent *generic mana costs*. Generic mana in costs can be paid with any type of mana.
- **107.4c** :yellow_circle: : The colorless mana symbol is used to represent both a *colorless mana*, and also to represent a *colorless mana cost* that can be paid only with one colorless mana.
- **107.4d** :yellow_circle: : The zero symbol (0) represents zero mana and is used as a placeholder for a cost that can be paid with no resources.
- **107.4e** :brown_circle: : Hybrid mana symbols are also colored mana symbols. Each one represents a cost that can be paid in one of two ways, as represented by the two halves of the symbol. A hybrid mana symbol is all of its component colors.
- **107.4f** :brown_circle: : Phyrexian mana symbols are colored mana symbols. They represent a cost that can be paid either with one mana of its color or by paying 2 life.
- **107.4g** :brown_circle: : In rules text, the Phyrexian symbol with no colored background means any of the five Phyrexian mana symbols.
- **107.4h** :brown_circle: : The snow mana symbol represents one mana in a cost. This mana can be paid with one mana of any type produced by a *snow permanent*. Effects that reduce the amount of generic mana you pay don't affect *snow mana costs*. Snow is neither a color nor a type of mana.
  1. *PROBLEM: See [Identifying Mana](#poi-mana-identification-problem----omit-in-toc) Problem* 


**107.5** :red_circle: The tap symbol in an activation cost means "Tap this permanent." A permanent that's already tapped can't be tapped again to pay the cost. Subject to *summoning sickness* (**302.6**).

1. *TODO: Implement tap and untap cost*

**107.6** :red_circle: The untap symbol in an activation cost means "Untap this permanent." A permanent that's already untapped can't be untapped again to pay the cost. Subject to *summoning sickness*.

**107.7** :red_circle: : Positive/Negative loyalty symbols in planeswalkers abilities costs means "Put/Remove N loyalty counters on this permanent".

**107.8** :brown_circle: : The level symbol includes either a range of numbers or a single number followed by a plus sign, and are followed by some abilities and/or *P/T*.

- **107.8a** :brown_circle: : "{LEVEL N1-N2} [Abilities] [P/T]" means "As long as this creature has *at least N1* and *less than N2* level counters on it, it has [P/T] and [abilities]."
- **107.8b** :brown_circle: : "{LEVEL N3+} [Abilities] [P/T]" means "As long as this creature has *at least N3* level counters on it, it has [P/T] and [abilities]."

**107.9** :large_blue_circle: : A tombstone icon has no effect on game play.

**107.10** :large_blue_circle: : A type icon appears in *Future Sight* alternate-frame cards to indicate the card type. This icon has no effect on game play.

**107.11** :black_circle: : The Planeswalker symbol is used on a planar die in the Planechase casual variant.

**107.12** :black_circle: : The Chaos symbol is used on a planar die in the Planechase casual variant.

**107.13** :large_blue_circle: : A color indicator is a circular symbol that appears to the left of the type line on some cards. The color of the symbol defines the card's color or colors.

**107.14** :brown_circle: :  The energy symbol represents one energy counter or one energy counter cost. To pay for it, a player removes one energy counter from themselves.

**107.15** :red_circle: : The text box of a Saga card contains chapter symbols, including a Roman numeral, next to an effect.

- **107.15a** :red_circle: : "{rN}—[Effect]" means "When the lore counters amount in this Saga becomes at least N, [effect]."
- **107.15b** :red_circle: : "{rN1}, {rN2}—[Effect]" is the same as "{rN1}—[Effect]" and "{rN2}—[Effect]."

### 108. Cards

**108.1** :large_blue_circle: : About official  card text in Wizard's website.

**108.2** :purple_circle: : Cards refer only to a Magic Card or an Object represented by a card.

- **108.2a** :large_blue_circle: : About card usual dimensions
- **108.2b** :purple_circle: : Tokens are not cards, even when card-like tokens are used.

**108.3** :red_circle: : The owner of the card is the player that started the game with that card or brought it into game.

- **108.3a** :black_circle: : In a *Planechase* game using the single planar deck option, the planar controller is considered to be the owner of all cards in the planar deck.
- **108.3b** :brown_circle: : About ownership of outside cards.

**108.4** :red_circle: : A card doesn't have a controller unless that card represents a permanent or spell; in those cases, its controller is determined by the rules for permanents or spells.

- **108.4a** :red_circle: : If anything asks for the controller of a card that doesn't have one (because it's not a permanent or spell), use its owner instead.

**108.5** :large_blue_circle: : About oversized cards only used in command zone.

**108.6** :large_blue_circle: : For more information about cards, see section 2, "Parts of a Card."

### 109. Objects

##### **POI**: OBJECTS DEFINITIONS <!-- omit in toc -->

**109.1** :yellow_circle: : An object is an ability on the stack, a card, a copy of a card, a token, a spell, a permanent, or an emblem.

**109.2** :purple_circle: : ABOUT CARD INTERPRETATION: If a spell/ability uses a description of an object that includes a card type or subtype, but doesn't include the word "card," "spell," "source," or "scheme," it means a ***permanent*** of that card type or subtype ***on the battlefield***.

- **109.2a** :purple_circle: : If a spell or ability uses a description of an object that includes the word "card" and the name of a zone, it means a ***card*** matching that description ***in the stated zone***.
- **109.2b** :purple_circle: : If a spell or ability uses a description of an object that includes the word "spell," it means a ***spell*** matching that description ***on the stack***.
- **109.2c** :purple_circle: : If a spell or ability uses a description of an object that includes the word "source," it means a source matching that description — either a source of an ability or a source of damage — ***in any zone***. See rule 609.7.
- **109.2d** :purple_circle: : If an ability of a scheme card includes the text "this scheme," it means the ***scheme card*** in the ***command zone*** on which that ability is printed.

**109.3** :yellow_circle: : An object's ***characteristics*** are name, mana cost, color, color indicator, card type, subtype, supertype, rules text, abilities, power, toughness, loyalty, hand modifier, and life modifier. Objects can have some or all of these *characteristics*. Any other information about an object isn't a *characteristic*.

**109.4** :yellow_circle: : Only objects on the stack or on the battlefield have a controller. Objects that are neither on the stack nor on the battlefield aren't controlled by any player. Exceptions below:

- **109.4a** :red_circle: : The controller of a mana ability is determined as though it were on the stack.
- **109.4b** :brown_circle: : An emblem is controlled by the player that puts it into the command zone.
- **109.4c** :black_circle: : In a Planechase game, a face-up plane or phenomenon card is controlled by the player designated as the planar controller.
- **109.4d** :black_circle: : In a Vanguard game, each vanguard card is controlled by its owner.
- **109.4e** :black_circle: : In an Archenemy game, each scheme card is controlled by its owner.
- **109.4f** :black_circle: : In a Conspiracy Draft game, each conspiracy card is controlled by its owner.

**109.5** :purple_circle:: ABOUT CARD INTERPRETATION: The words "you" and "your" on an object refer to the object's controller, its would-be controller (if a player is attempting to play, cast, or activate it), or its owner (if it has no controller). For a static ability, this is the current controller of the object it's on. For an activated ability, this is the player who activated the ability. For a triggered ability, this is the controller of the object when the ability triggered, unless it's a delayed triggered ability. To determine the controller of a delayed triggered ability, see rules 603.7d-f.

### 110. Permanents

##### **POI**: PERMANENTS DEFINITIONS <!-- omit in toc -->

**110.1** :yellow_circle: : A permanent is a card or token on the battlefield. A permanent remains on the battlefield indefinitely. A card or token becomes a permanent as it enters the battlefield and it stops being a permanent as it's moved to another zone by an effect or rule.

**110.2** :yellow_circle: : A permanent's owner is the same as the owner of the card that represents it (unless it's a token; see rule 111.2). A permanent's controller is, by default, the player under whose control it entered the battlefield. Every permanent has a controller.

- **110.2a** :red_circle: : If an effect instructs a player to put an object onto the battlefield, that object enters the battlefield under that player's control unless the effect states otherwise.
- **110.2b** :brown_circle: : If an effect causes a player to gain control of another player's permanent spell, the first player controls the permanent that spell becomes, but the permanent's controller by default is the player who put that spell onto the stack. (This distinction is relevant in multiplayer games; see rule 800.4c.)
  1. *NOTE: This is an super edgy case, player A must cast a spell, player B must steal the spell while in the stack, it must resolve to a permanent under B's control, then B must lose while another C player is still in the game, then that permanent returns to A's control*

**110.3** :red_circle: : A nontoken permanent's characteristics are the same as those printed on its card, as modified by any continuous effects.

**110.4** :green_circle: : There are five permanent types: artifact, creature, enchantment, land, and planeswalker.

- **110.4a** :purple_circle: : The term "permanent card" means an artifact, creature, enchantment, land, or planeswalker card.
- **110.4b** :purple_circle: : The term "permanent spell" means an artifact, creature, enchantment, or planeswalker spell.
- **110.4c** :red_circle: : If a permanent somehow loses all its permanent types, it remains on the battlefield. It's still a permanent.


**110.5** :green_circle: : A permanent's status is its physical state. There are four status categories, each of which has two possible values: tapped/untapped, flipped/unflipped, face up/face down, and phased in/phased out. Each permanent always has one of these values for each of these categories.

- **110.5a** :purple_circle: : Status is not a characteristic, though it may affect a permanent's characteristics.
- **110.5b** :green_circle: : Permanents enter the battlefield untapped, unflipped, face up, and phased in unless a spell or ability says otherwise.
- **110.5c** :green_circle: : A permanent retains its status until a spell, ability, or turn-based action changes it, even if that status is not relevant to it.
- **110.5d** :green_circle: : Only permanents have status. Cards not on the battlefield do not.

### 111. Tokens

**111.1** :green_circle: : A token is a marker used to represent any permanent that isn't represented by a card.

**111.2** :red_circle: : The player who creates a token is its owner. The token enters the battlefield under that player's control.

**111.3** :large_blue_circle: : The effect that creates a token may define the values of any number of characteristics for the token.

**111.4** :red_circle: : A effect that creates a token sets both its name and its subtype(s). If it doesn't specify the name of the token, it enters with its name the same as its subtype(s).

**111.5** :red_circle: : If a effect would create a token, but a rule or effect states that a permanent with one or more of that token's characteristics can't enter the battlefield, the token is not created.

1. *TODO: create verification rule on token creation*

**111.6** :large_blue_circle: : A token is subject to anything that affects permanents in general or that affects the token's card type or subtype. A token isn't a card.

**111.7** :red_circle: : **SBA:** A token that's in a zone other than the battlefield ceases to exist. This is a state-based action.

1. *NOTE: if a token changes zones, applicable triggered abilities will trigger before the token ceases to exist.*

**111.8** :red_circle: : A token that has left the battlefield can't move to another zone or come back onto the battlefield. If such a token would change zones, it remains in its current zone instead. It ceases to exist the next **SBA-check**.

1. *TODO: add "triedChangeZone" flag to tokens, signalizing desctruction*

**111.9** :large_blue_circle: : About named legendary tokens following usual rules.

**111.10** :red_circle: : About predefined tokens.

- **111.10a** :red_circle: : A Treasure token is a colorless Treasure artifact token with "%T, Sacrifice this artifact: Add one mana of any color."
- **111.10b** :red_circle: : A Food token is a colorless Food artifact token with "%2, %T, Sacrifice this artifact: You gain 3 life."
- **111.10c** :red_circle: : A Gold token is a colorless Gold artifact token with "Sacrifice this artifact: Add one mana of any color."

### 112. Spells

##### **POI**: SPELL DEFINITIONS <!-- omit in toc -->

**112.1** :green_circle:: A spell is a card on the stack.

- **112.1a** :yellow_circle: : A copy of a spell is also a spell, even if it has no card associated with it.
- **112.1b** :yellow_circle: : If a player casts a copy of a object, that copy is a spell as well.
  
**112.2** :red_circle: : A spell's owner is the same as the owner of the card that represents it, unless it's a copy. In that case, the owner of the spell is the player under whose control it was put on the stack. A spell's controller is, by default, the player who put it on the stack. Every spell has a controller.

**112.3** :red_circle: : A noncopy spell's characteristics are the same as those printed on its card, as modified by any continuous effects.

**112.4** :red_circle: : If an effect changes any characteristics of a permanent spell, the effect continues to apply to the permanent when the spell resolves.

1. *Example: If an effect changes a black creature spell to white, the creature is white when it enters the battlefield and remains white for the duration of the effect changing its color.*

### 113. Abilities

##### **POI**: ABILITIES DEFINITIONS <!-- omit in toc -->
     
**113.1** :yellow_circle:: An ability can be one of three things:

- **113.1a** :yellow_circle: : An ability can be a characteristic an object has that lets it affect the game. 
- **113.1b** :yellow_circle: : An ability can be something that a player has that changes how the game affects the player. 
- **113.1c** :yellow_circle: : An ability can be an activated or triggered ability on the stack. This kind of ability is an object.

**113.2** :purple_circle: : Abilities can affect the objects they're on. They can also affect other objects and/or players.

- **113.2a** :purple_circle: : Abilities can be beneficial or detrimental.
- **113.2b** :yellow_circle: : An additional cost or alternative cost to cast a card is an ability of the card.
- **113.2c** :yellow_circle: : An object may have multiple abilities. If an object has multiple instances of the same ability, each instance functions independently.
- **113.2d** :yellow_circle: : Abilities can generate one-shot effects or continuous effects. Some continuous effects are replacement effects or prevention effects.

**113.3** :green_circle: : There are four general categories of abilities:

- **113.3a** :yellow_circle: : Spell abilities are instructions of instant or sorcery spells while they are resolving. Any text on an instant or sorcery spell is a spell ability unless it's an activated ability, a triggered ability, or a static ability that fits the criteria described in rule 113.6.
- **113.3b** :yellow_circle: : Activated abilities have a cost and an effect.
- **113.3c** :yellow_circle: : Triggered abilities have a trigger condition and an effect.
- **113.3d** :yellow_circle: : Static abilities are written as statements. Static abilities create continuous effects which are active while the object with the ability is in the appropriate zone.

**113.4** :yellow_circle: : Some activated abilities and some triggered abilities are mana abilities. Mana abilities follow special rules. See rule 605.

**113.5** :yellow_circle: : Some activated abilities are loyalty abilities. Loyalty abilities follow special rules: See rule 606.

**113.6** :red_circle: : Abilities of an instant or sorcery spell usually function only while that object is on the stack. Abilities of all other objects usually function only while that object is on the battlefield. The exceptions are as follows:

- **113.6a** :red_circle: : Characteristic-defining abilities function everywhere, even outside the game.
- **113.6b** :red_circle: : An ability that states which zones it functions in functions only from those zones.
- **113.6c** :red_circle: : An object's ability about its alternative cost or its cost's modifications functions on the stack.
- **113.6d** :red_circle: : An object's ability that modifies how it can be played functions wherever it can be cast from and on the stack. An object's ability that grants it another ability that modifies how it can be played functions only on the stack.
- **113.6e** :red_circle: : An object's ability that modifies where it can be played from functions everywhere, even outside the game.
- **113.6f** :red_circle: : An object's ability that states it can't be countered functions on the stack.
- **113.6g** :red_circle: : An object's ability that modifies how it enters the battlefield functions as it is entering the battlefield.
- **113.6h** :red_circle: : An object's ability that states counters can't be put on itself functions when it is entering the battlefield and while it is on the battlefield.
- **113.6i** :red_circle: : An object's activated ability that has a cost that can't be paid while the object is on the battlefield functions from any zone in which its cost can be paid.
- **113.6j** :red_circle: : A trigger condition that can't trigger from the battlefield functions in all zones it can trigger from. Other trigger conditions of the same triggered ability may function in different zones.
  1. *Example: Absolver Thrull has the ability "When Absolver Thrull enters the battlefield or the creature it haunts dies, destroy target enchantment." The first trigger condition functions from the battlefield and the second trigger condition functions from the exile zone. (see rule 702.54, "Haunt.")*
- **113.6k** :red_circle: : An ability whose cost or effect specifies that it moves its object out of a particular zone functions only in that zone, unless it specifies that the object is put beforehand into that zone.
  1. *Example: Reassembling Skeleton says "%1%B: Return Reassembling Skeleton from your graveyard to the battlefield tapped." A player may activate this ability only if Reassembling Skeleton is in their graveyard.*
- **113.6m** :brown_circle: : An ability that modifies the rules for deck construction functions before the game begins.
- **113.6n** :black_circle: : Abilities of emblems, plane cards, vanguard cards, scheme cards, and conspiracy cards function in the command zone.

**113.7** :yellow_circle: : The source of an ability is the object that generated it.

- **113.7a** :red_circle: : Once activated or triggered, an ability exists on the stack independently of its source. Some abilities cause a source to do something rather than the ability doing anything directly. The source can still perform the action even though it no longer exists.
  
**113.8** :red_circle: : The controller of an activated ability on the stack is the player who activated it. The controller of a triggered ability on the stack (other than a delayed triggered ability) is the controller/owner of the source when it triggered.

**113.9** :red_circle: : Activated and triggered abilities on the stack aren't spells, and therefore can't be countered by anything that counters only spells. Activated and triggered abilities on the stack can be countered by effects that specifically counter abilities. Static abilities don't use the stack and thus can't be countered at all.

**113.10** :red_circle: : Effects can add or remove abilities of objects.

- **113.10a** :red_circle: : An effect that adds an activated ability may include activation instructions for that ability.
- **113.10b** :red_circle: : Effects that remove an ability remove all instances of it.
- **113.10c** :red_circle: : If two or more effects add and remove the same ability, in general the most recent one prevails. See rule 613.

**113.11** :red_circle: : Effects can stop an object from having a specified ability. 
  
**113.12** :red_circle: : An effect that sets an object's characteristic, or simply states a quality of that object, is different from an ability granted by an effect. When an object "gains" or "has" an ability, that ability can be removed by another effect. If an effect defines a characteristic of the object ("[permanent] is [characteristic value]"), it's not granting an ability. (see rule 604.3.) Similarly, if an effect states a quality of that object ("[creature] can't be blocked," for example), it's neither granting an ability nor setting a characteristic.
Example: Muraganda Petroglyphs reads, "Creatures with no abilities get +2/+2." A Runeclaw Bear (a creature with no abilities) enchanted by an Aura that says "Enchanted creature has flying" would not get +2/+2. A Runeclaw Bear enchanted by an Aura that says "Enchanted creature is red" or "Enchanted creature can't be blocked" would get +2/+2.