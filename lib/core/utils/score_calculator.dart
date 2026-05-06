class ScoreCalculator {
  static Map<String, dynamic> calculateHealthScore(String clinicName, Map<String, dynamic> formData) {
    // Marketing Score
    int mkt = 40;
    if (formData['instagram'] == 'active') mkt += 25;
    else if (formData['instagram'] == 'basic') mkt += 12;
    if (formData['source'] == 'mixed') mkt += 20;
    else if (formData['source'] == 'ads') mkt += 15;
    final budget = double.tryParse(formData['mktbudget'].toString()) ?? 0;
    if (budget > 5000) mkt += 10;
    else if (budget > 2000) mkt += 5;
    final mktScore = mkt.clamp(30, 95);

    // Operations Score
    int ops = 30;
    if (formData['crm'] == 'advanced') ops += 35;
    else if (formData['crm'] == 'basic' || formData['crm'] == 'excel') ops += 20;
    if (formData['response'] == 'instant') ops += 20;
    else if (formData['response'] == 'fast') ops += 12;
    if (formData['booking'] == 'mixed') ops += 10;
    final opScore = ops.clamp(30, 95);

    // Patient Experience Score
    int px = 40;
    final retention = double.tryParse(formData['retention'].toString()) ?? 0;
    if (retention > 60) px += 35;
    else if (retention > 40) px += 20;
    final noShow = double.tryParse(formData['noshow'].toString()) ?? 100;
    if (noShow < 10) px += 20;
    else if (noShow < 20) px += 10;
    final expScore = px.clamp(30, 95);

    // Financial Score
    final patients = double.tryParse(formData['patients'].toString()) ?? 0;
    final price = double.tryParse(formData['price'].toString()) ?? 0;
    final revenue = double.tryParse(formData['revenue'].toString()) ?? 0;
    final theoreticalRev = patients * price;
    int fin = 40;
    if (theoreticalRev > 0) {
      if (revenue >= theoreticalRev * 0.85) fin += 40;
      else if (revenue >= theoreticalRev * 0.70) fin += 25;
      else if (revenue >= theoreticalRev * 0.50) fin += 12;
    }
    final finScore = fin.clamp(30, 95);

    // Team Score
    int team = 45;
    if (formData['doctors'] == '4-6' || formData['doctors'] == '7+') team += 20;
    else if (formData['doctors'] == '2-3') team += 10;
    if (retention > 50) team += 25;
    final teamScore = team.clamp(30, 95);

    // Growth Score
    int growth = 30;
    if (formData['goal'] == 'scale') growth += 40;
    else if (formData['goal'] == 'grow50') growth += 25;
    final growthScore = growth.clamp(30, 95);

    final overall = ((mktScore + opScore + finScore + expScore + teamScore + growthScore) / 6).round();
    final missed = (revenue * (noShow / 100 + 0.15)).round();

    return {
      'overall_score': overall,
      'overall_status': overall > 80 ? 'أداء طبي متميز' : 'بزنس واعد يحتاج أتمتة',
      'scores': {
        'marketing': mktScore,
        'operations': opScore,
        'financial': finScore,
        'team': teamScore,
        'growth': growthScore,
        'experience': expScore,
      },
      'missed_revenue': missed,
      'target_revenue': (revenue * 1.5).round(),
      'executive_summary': 'تحليل أولي: عيادتك تمتلك إمكانات نمو كبيرة، ولكن ثغرات التشغيل الحالية تسبب تسرباً مالياً ملحوظاً.',
      'action_steps': [
        {'title': 'أتمتة المتابعة', 'desc': 'تفعيل نظام WhatsApp Automation لتقليل الـ No-show.', 'gain': '+25% نمو'},
        {'title': 'تحسين التحويل', 'desc': 'تدريب فريق الاستقبال على مهارات البيع الهاتفي.', 'gain': '+15% نمو'},
        {'title': 'تحسين الأداء', 'desc': 'متابعة مؤشرات الأداء بشكل دوري.', 'gain': '+10% نمو'},
      ],
      'currency': formData['currency'],
    };
  }
}
