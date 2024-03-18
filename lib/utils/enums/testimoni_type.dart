enum TestimoniType {
  text('text'),
  image('image');

  final String type;
  const TestimoniType(this.type);
}

extension ConvertTweet on String {
  TestimoniType toTweetTypeEnum() {
    switch (this) {
      case 'text':
        return TestimoniType.text;
      case 'image':
        return TestimoniType.image;
      default:
        return TestimoniType.text;
    }
  }
}
