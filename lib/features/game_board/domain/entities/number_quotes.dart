import 'dart:math';

class NumberQuotes {
  static final Map<int, List<String>> _quotes = {
    1: [
      "One shot, one kill. The absolute pinnacle of precision hacking.",
      "The singular node. A system breached on the very first exploit.",
      "The identity element. A flawless operation leaving zero trace.",
      "First contact. The firewall folded before the first byte could bounce.",
      "Instant access. The administrator password must have been 'password'."
    ],
    2: [
      "Binary code. Standard 0 and 1, the perfect duo of digital design.",
      "Double helix. The dual-stranded blueprint of organic code.",
      "Mitosis. A single cell splits into two, doubling its processing power.",
      "Dual-core processor. Twice the speed, twice the efficiency.",
      "Two-factor authentication. A secure second layer that couldn't stop you."
    ],
    3: [
      "The rule of thirds. A classic formula for visual balance and composition.",
      "Triangulation. Three nodes are all that's required to pin down any coordinate.",
      "Triple DES. An old-school cryptographic standard that uses three keys.",
      "The triangle. The simplest polygon and the strongest structure in geometry.",
      "Three-way handshake. SYN, SYN-ACK, ACK. The foundation of TCP connections."
    ],
    4: [
      "Four: The Nibble. Half of a byte, and a neat four bits of data.",
      "Quad-core architecture. Powering smooth multi-threaded computations.",
      "Four cardinal directions. North, South, East, and West direct our path.",
      "The tetrahedron. A perfect three-dimensional pyramid with four faces.",
      "IPv4 address. Expressed as four octets, mapping the classic internet."
    ],
    5: [
      "Five: The golden ratio. The number 5 is the key to constructing the golden spiral.",
      "Human senses. Five channels connecting our consciousness to reality.",
      "Platonic solids. There are exactly five regular three-dimensional shapes.",
      "Fibonacci term. Five is the fifth number in the Fibonacci sequence.",
      "Pentagon. The five-sided polygon representing ultimate security."
    ],
    6: [
      "Six: A perfect number. The sum of its proper divisors (1 + 2 + 3) equals 6.",
      "Hexagonal honeycombs. Nature's most space-efficient tile configuration.",
      "Carbon chemistry. The six-carbon benzene ring is the basis of organic life.",
      "Six degrees of separation. Any two people are connected by at most six steps.",
      "Standard dice. A cubic die has six faces, each representing a path of chance."
    ],
    7: [
      "Seven: The OSI model. A network stack built on seven layers of abstraction.",
      "Lucky seven. A symbol of fortune and completion across many cultures.",
      "Rainbow spectrum. Light refracting into seven distinct colors.",
      "Classic keyboard row. The number of keys separating basic shift ciphers.",
      "Seven stars of the Big Dipper. Navigating the night sky since antiquity."
    ],
    8: [
      "Eight the Perfect Cube. Eight is the only Fibonacci number (other than 1) that is a perfect cube (2³ = 8).",
      "Eight the Byte. Eight bits form a single byte of digital information.",
      "Solar Planets. There are exactly eight planets orbiting our sun.",
      "Chessboard grid. The battlefield of chess is an 8 by 8 grid of squares.",
      "Octopus arms. True to its Greek prefix, an octopus commands eight limbs."
    ],
    9: [
      "Nine: Almost double digits. The largest single-digit number in base-10.",
      "Sudoku grid. Nine squares of nine cells make up the logic puzzle.",
      "Planet Pluto. Historically counted as the ninth planet of our solar system.",
      "Enneagram system. A framework mapping nine distinct human personality types.",
      "Nonagon geometry. A nine-sided polygon represents structural complexity."
    ],
    10: [
      "Ten: Decimal base. Our counting system is base-10, inspired by our ten fingers.",
      "Metric multiplier. The metric system measures the physical world in powers of ten.",
      "Decibel scale. An increase of 10 decibels is a tenfold increase in intensity.",
      "Ten-code communications. Used by emergency services for quick messages.",
      "Binary value of two. In binary representation, '10' represents the decimal number two."
    ],
    11: [
      "Eleven: The first palindrome. The smallest double-digit palindromic prime.",
      "OS computer systems. Windows 11 brings modern design to the desktop.",
      "Solar cycle. Solar activity peaks and troughs every eleven years.",
      "Hendecagon geometry. An eleven-sided polygon is a hendecagon.",
      "Deep space probe. Apollo 11 was the historic flight that put humans on the Moon."
    ],
    12: [
      "Twelve: The Dozen. A highly composite number, easily divided into halves, thirds, and quarters.",
      "Lunar cycle. The year is divided into twelve months, matching the lunar phases.",
      "Duodecimal base. Base-12 is often praised as a more natural mathematical base than 10.",
      "Zodiac signs. Twelve constellations guiding celestial navigation.",
      "Tensegrity. A structure of twelve struts held in perfect tension."
    ],
    13: [
      "Thirteen: Baker's dozen. Bakers traditionally added a thirteenth loaf for good measure.",
      "Folk superstition. Often considered unlucky, though mathematically a strong prime.",
      "Fibonacci number. Thirteen is the seventh number in the Fibonacci sequence.",
      "USA foundation. Thirteen original colonies declared independence in 1776.",
      "Lunar calendar. Some traditional calendars track thirteen lunar cycles per year."
    ],
    14: [
      "Fourteen: Carbon dating. Carbon-14 isotopes help trace the age of ancient organic matter.",
      "Sonnets. A classic Shakespearean sonnet contains exactly fourteen lines.",
      "Fortnight. A measurement of time spanning exactly fourteen days.",
      "Silicon atomic number. Silicon, the backbone of modern computing chips, is element 14.",
      "Phases of the moon. It takes fourteen days to transition from a new moon to a full moon."
    ],
    15: [
      "Fifteen: Magic square. A 3x3 grid where every row, column, and diagonal sums to 15.",
      "Phosphorus atomic number. The highly reactive element 15 is vital for cellular energy.",
      "Quindecagon. A polygon with fifteen sides and fifteen interior angles.",
      "Binary max value. 15 is the maximum decimal value of a 4-bit nibble (1111 in binary).",
      "Standard game. A classic fifteen puzzle challenges players to slide tiles in a grid."
    ]
  };

  static String? getRandomQuote(int attempts) {
    final list = _quotes[attempts];
    if (list == null || list.isEmpty) {
      return null;
    }
    final random = Random();
    return list[random.nextInt(list.length)];
  }
}
