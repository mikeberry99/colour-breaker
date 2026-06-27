import 'dart:math';

class NumberQuotes {
  static final Map<int, List<String>> _quotes = {
    1: [
      "One - One shot, one kill. The absolute pinnacle of precision hacking.",
      "One - Instant access. The administrator password must have been 'password'.",
      "One - The loneliest number. In mathematics, it is the only number that is neither prime nor composite.",
      "One - A single byte. The building block of digital existence, where every journey begins.",
      "One - The monad. In philosophy, the indivisible, ultimate unit of existence."
    ],
    2: [
      "Two - Binary code. The foundation of digital reality, built entirely on zeroes and ones.",
      "Two - The only even prime. A mathematical anomaly that breaks the rules of divisibility.",
      "Two - Double helix. The dual-stranded structure of DNA, nature's most elegant database.",
      "Two - Quantum superposition. A qubit can exist as zero, one, or both simultaneously.",
      "Two - The twin primes. Pairs of prime numbers that differ by exactly two, an infinite mathematical mystery."
    ],
    3: [
      "Three - The triangle. The simplest polygon and the strongest structure in geometry.",
      "Three - The three-body problem. In physics, predicting the motion of three celestial bodies is famously chaotic.",
      "Three - RGB color space. Red, green, and blue combine to create every color on your screen.",
      "Three - The holy trinity of web development. HTML, CSS, and JavaScript run the modern internet.",
      "Three - Pi approximation. 3.14 is the universally recognized start to the ratio of a circle's circumference to its diameter."
    ],
    4: [
      "Four - The Nibble. Half of a byte, an essential four bits of data in computing history.",
      "Four - The four color theorem. Any map can be colored with just four colors so no adjacent regions share a hue.",
      "Four - DNA nucleobases. Adenine, cytosine, guanine, and thymine write the code of all life.",
      "Four - The fourth dimension. In relativistic physics, time joins the three dimensions of space.",
      "Four - IPv4 architecture. The classic protocol that mapped the first iteration of the global internet."
    ],
    5: [
      "Five - The golden ratio. The number 5 is intimately tied to phi, the mathematical fingerprint of beauty.",
      "Five - Platonic solids. The universe allows for exactly five regular three-dimensional shapes.",
      "Five - High five for Apollo. The F-1 engine cluster on the Saturn V rocket that took humanity to the moon.",
      "Five - The pentagram. A five-pointed star drawn with five straight strokes, steeped in ancient mysticism.",
      "Five - Boron's atomic number. The cosmic element created entirely by cosmic ray spallation, not stellar nucleosynthesis."
    ],
    6: [
      "Six - Six degrees of separation. Any two people are connected by at most six steps.",
      "Six - Standard dice. A cubic die has six faces, each representing a path of chance.",
      "Six - A perfect number. The sum of its divisors (1, 2, and 3) equals the number itself.",
      "Six - Carbon chemistry. The element of life, with six protons binding the organic universe together.",
      "Six - Hexagonal honeycombs. Nature's most mathematically space-efficient tile configuration."
    ],
    7: [
      "Seven - Lucky seven. A symbol of fortune and completion across many cultures.",
      "Seven - The OSI model. A conceptual framework dividing network communication into seven distinct layers.",
      "Seven - Millennium Prize Problems. The seven greatest unsolved puzzles in mathematics, each worth a million dollars.",
      "Seven - The limit of short-term memory. The human brain can typically hold seven items in its working memory.",
      "Seven - Rainbow spectrum. Isaac Newton divided the visible spectrum into seven distinct colors."
    ],
    8: [
      "Eight - Chessboard grid. The battlefield of chess is an 8 by 8 grid of squares.",
      "Eight - The Byte. Eight bits form a single byte, the fundamental unit of digital storage.",
      "Eight - A perfect cube. The only Fibonacci number, other than one, that is a perfect cube.",
      "Eight - Infinity upright. Rotate the symbol for infinity ninety degrees, and you get the number eight.",
      "Eight - The octet rule. In chemistry, atoms are most stable when their valence shell holds eight electrons."
    ],
    9: [
      "Nine - The magic nine. Any number multiplied by nine will have digits that sum back to nine.",
      "Nine - Cloud nine. The highest level of a towering cumulonimbus cloud, now synonymous with euphoria.",
      "Nine - Sudoku logic. A grid of nine by nine cells that requires pure deduction, not math, to solve.",
      "Nine - The Enneagram. A geometric figure mapping nine distinct nodes of human personality types.",
      "Nine - Almost double digits. The largest single-digit number in the base-10 counting system."
    ],
    10: [
      "Ten - Decimal base. Our counting system is base-10, inspired by our ten fingers.",
      "Ten - Metric multiplier. The international system of units measures the physical world in neat powers of ten.",
      "Ten - Tetractys. A triangular figure of ten points, revered by the Pythagoreans as a mystical symbol.",
      "Ten - Decibel scale. A logarithmic unit where an increase of ten represents a tenfold increase in acoustic energy.",
      "Ten - Binary translation. In the language of computers, the decimal number two is written simply as '10'."
    ],
    11: [
      "Eleven - The first palindrome. The smallest double-digit palindromic prime number.",
      "Eleven - M-theory dimensions. Advanced string theory suggests the universe operates in exactly eleven dimensions.",
      "Eleven - Apollo 11. The historic spaceflight that put the first humans on the lunar surface.",
      "Eleven - Solar cycle. The sun's magnetic field completely flips its polarity every eleven years.",
      "Eleven - The hendecagon. A complex polygon boasting exactly eleven sides and eleven angles."
    ],
    12: [
      "Twelve - Highly composite. A mathematically elegant number cleanly divisible by one, two, three, four, and six.",
      "Twelve - Duodecimal base. Base-12 mathematics is heavily advocated for its superior divisibility over base-10.",
      "Twelve - The chromatic scale. Western music divides an octave into exactly twelve distinct semitones.",
      "Twelve - Tensegrity. A synergetic structure requiring a minimum of twelve struts to maintain perfect tension.",
      "Twelve - Synodic months. The approximate number of lunar cycles it takes to complete one solar year."
    ],
    13: [
      "Thirteen - Baker's dozen. A historical practice where bakers added a thirteenth loaf to avoid fines for shortchanging.",
      "Thirteen - Archimedean solids. There are exactly thirteen highly symmetric, semi-regular convex polyhedra.",
      "Thirteen - Prime superstition. Mathematically robust but culturally feared, triskaidekaphobia is the fear of this prime number.",
      "Thirteen - Fibonacci sequence. The seventh number in nature's favorite mathematical sequence.",
      "Thirteen - Aluminum's atomic number. The most abundant metal in the Earth's crust is element 13."
    ],
    14: [
      "Fourteen - Carbon dating. Carbon-14 isotopes act as a radioactive clock to trace the age of ancient organic matter.",
      "Fourteen - Silicon's signature. Element 14 is the semiconductor backbone of every modern computing chip.",
      "Fourteen - Sonnet structure. A classic Shakespearean poem is rigidly locked to exactly fourteen lines.",
      "Fourteen - The cuboctahedron. A polyhedral shape composed of exactly fourteen faces: eight triangular and six square.",
      "Fourteen - Fortnight. A linguistic measurement of time spanning exactly fourteen nights."
    ],
    15: [
      "Fifteen - Magic square. A 3x3 mathematical grid where every row, column, and diagonal seamlessly sums to 15.",
      "Fifteen - Phosphorus. Element 15 is highly reactive and absolutely vital for biological cellular energy.",
      "Fifteen - Binary maximum. The absolute maximum decimal value that can be squeezed into a 4-bit nibble (1111).",
      "Fifteen - The 15 Puzzle. A classic sliding grid game that revolutionized mechanical logic puzzles.",
      "Fifteen - Quarter hour. A 15-minute chunk, making it a highly composite wedge of the 60-minute clock."
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
