class UploadPdf {
  static const uploadPdf = """
    mutation uploadPdf(\$upload: Upload!) {
      uploadPdf(upload: \$upload)
    }
  """;
}
