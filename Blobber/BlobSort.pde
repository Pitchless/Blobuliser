/**
 * Static class to hold sort Comparators for sorting arrays of blobs
 */
static class BlobSort {

  static Comparator X = new Comparator() {
      int compare(Object oa, Object ob) {
        Point a = ((Blob)oa).centroid;
        Point b = ((Blob)ob).centroid;
        if (a.x == b.x) return 0;
        return a.x < b.x ? -1 : 1;
      }
  };

  static Comparator Y = new Comparator() {
      int compare(Object oa, Object ob) {
        Point a = ((Blob)oa).centroid;
        Point b = ((Blob)ob).centroid;
        if (a.y == b.y) return 0;
        return a.y < b.y ? -1 : 1;
      }
  };
}
