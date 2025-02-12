int getComponentWidth() {
  return width - (PADDING_EDGES * 2);
}

int[] getTrueIndexes(boolean[] arr) {
  ArrayList<Integer> indexes = new ArrayList<Integer>();
  
  for (int i = 0; i < arr.length; i++) {
    if (arr[i]) {
      indexes.add(i);
    }
  }
  
  // Convert ArrayList<Integer> to int[]
  int[] result = new int[indexes.size()];
  for (int i = 0; i < indexes.size(); i++) {
    result[i] = indexes.get(i);
  }
  
  return result;
}
