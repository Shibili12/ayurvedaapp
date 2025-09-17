class TreatmentSelection {
  final String treatmentId;
  final String treatmentName;
  int maleCount;
  int femaleCount;

  TreatmentSelection({
    required this.treatmentId,
    required this.treatmentName,
    this.maleCount = 0,
    this.femaleCount = 0,
  });

  TreatmentSelection copyWith(
      {required int maleCount, required int femaleCount}) {
    return TreatmentSelection(
      treatmentId: treatmentId,
      treatmentName: treatmentName,
    );
  }
}
