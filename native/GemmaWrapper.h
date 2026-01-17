#ifndef GEMMA_WRAPPER_H
#define GEMMA_WRAPPER_H

class GemmaWrapper {
public:
  static void init(const char* modelPath);
  static const char* query(const char* prompt);
  static void reset();
};

#endif
