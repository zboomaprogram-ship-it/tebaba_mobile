import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LandingSections {
  static Widget buildWhy() {
    final points = [
      {'icon': '🚀', 'title': 'من Lead لمريض دائم', 'desc': 'أتمتة كاملة لرحلة المريض تضمن عدم ضياع أي فرصة.'},
      {'icon': '🧠', 'title': 'حوّل البيانات إلى قرارات', 'desc': 'ذكاء اصطناعي يحلل أرقامك ويقترح خطوات نمو فعلية.'},
      {'icon': '⚡', 'title': 'أتمتة ذكية بدون فوضى', 'desc': 'أنظمة تعمل في الخلفية لتوفير وقتك ومجهود فريقك.'},
      {'icon': '📈', 'title': 'ROI قابل للقياس', 'desc': 'كل قرش تنفقه في التسويق ستعرف عائده بدقة متناهية.'},
    ];

    return Column(
      children: [
        _buildHeader('لماذا طِبابة؟', '💡', 'القوة التي يحتاجها مركزك الطبي'),
        const SizedBox(height: 30),
        ...points.map((p) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1DD9A0).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(p['icon']!, style: const TextStyle(fontSize: 20)),
              ).animate().scale(duration: 400.ms),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(p['desc']!, style: const TextStyle(fontSize: 12, color: Colors.white54)),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.1, end: 0),
        )),
      ],
    );
  }

  static Widget buildAIExplain() {
    final steps = [
      '📥 استقبال بيانات',
      '🔍 تحليل 6 محاور',
      '📊 نمذجة الأداء',
      '🎯 توليد توصيات',
      '✅ قرارات تنفيذية',
    ];

    return Column(
      children: [
        _buildHeader('كيف يعمل AI؟', '🧠', 'خطوات تحويل البيانات لنتائج'),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: List.generate(steps.length, (index) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1221),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFF1DD9A0).withOpacity(0.2)),
                    ),
                    child: Center(child: Text(steps[index], style: const TextStyle(fontWeight: FontWeight.bold))),
                  ).animate().fadeIn(delay: (index * 200).ms).slideY(begin: 0.2, end: 0),
                  if (index < steps.length - 1)
                    Container(
                      height: 30,
                      width: 2,
                      color: const Color(0xFF1DD9A0).withOpacity(0.3),
                    ).animate().fadeIn(delay: (index * 200 + 100).ms),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  static Widget buildJourney() {
    final steps = [
      {'icon': '📢', 'label': 'Lead من إعلان'},
      {'icon': '💬', 'label': 'واتساب'},
      {'icon': '🤖', 'label': 'AI يرد فورياً'},
      {'icon': '📅', 'label': 'حجز ذكي'},
      {'icon': '🏥', 'label': 'زيارة المركز'},
      {'icon': '📲', 'label': 'Follow-up ذكي'},
      {'icon': '♻️', 'label': 'Retention دائم'},
    ];

    return Column(
      children: [
        _buildHeader('رحلة المريض', '🔄', 'من أول إعلان لآخر زيارة'),
        const SizedBox(height: 30),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: steps.length,
            separatorBuilder: (context, index) => const Icon(Icons.arrow_back, color: Colors.white24, size: 16),
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white10,
                      child: Text(steps[index]['icon']!, style: const TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      steps[index]['label']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10, color: Colors.white70),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static Widget buildSystems() {
    final systems = [
      {
        'icon': '👤',
        'title': 'نظام تجربة المريض',
        'desc': 'رحلة احترافية من الاكتشاف للولاء',
        'color': const Color(0xFF1DD9A0),
      },
      {
        'icon': '👨‍⚕️',
        'title': 'نظام إدارة البزنس',
        'desc': 'لوحة تحكم شاملة تعطيك رؤية 360°',
        'color': const Color(0xFF4D9FFF),
      },
      {
        'icon': '⚙️',
        'title': 'محرك التشغيل والنمو',
        'desc': 'الأتمتة الذكية التي تشغّل مركزك بكفاءة',
        'color': const Color(0xFFF0C040),
      },
    ];

    return Column(
      children: [
        _buildHeader('البنية التقنية', '🧩', '3 أنظمة متكاملة لنمو مستدام'),
        const SizedBox(height: 20),
        ...systems.map((sys) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1221),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: (sys['color'] as Color).withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Text(sys['icon'] as String, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sys['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(sys['desc'] as String, style: const TextStyle(fontSize: 12, color: Colors.white54)),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  static Widget buildMetrics() {
    final metrics = [
      {'val': '+40%', 'label': 'زيادة المرضى', 'icon': '👥'},
      {'val': '3.2x', 'label': 'تحسين Conversion', 'icon': '🎯'},
      {'val': '-60%', 'label': 'تخفيض CAC', 'icon': '💰'},
      {'val': '85%', 'label': 'Retention Rate', 'icon': '🔄'},
    ];

    return Column(
      children: [
        _buildHeader('نتائج فعلية', '📊', 'أرقام حقيقية من عملائنا'),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1221),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(metrics[index]['icon']!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 5),
                  Text(metrics[index]['val']!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1DD9A0))),
                  Text(metrics[index]['label']!, style: const TextStyle(fontSize: 10, color: Colors.white54)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  static Widget buildPricing() {
    final tiers = [
      {'name': '🌱 ستارتر', 'price': '999', 'desc': 'للعيادات الناشئة'},
      {'name': '🚀 برو', 'price': '2,499', 'desc': 'للمراكز الطبية', 'featured': true},
      {'name': '👑 انتربرايز', 'price': 'تواصل معنا', 'desc': 'للمستشفيات'},
    ];

    return Column(
      children: [
        _buildHeader('الأسعار', '💎', 'استثمار ذكي في نمو بزنسك'),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: tiers.length,
            itemBuilder: (context, index) {
              final tier = tiers[index];
              final isFeatured = tier['featured'] == true;
              return Container(
                width: 200,
                margin: const EdgeInsets.only(left: 15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isFeatured ? const Color(0xFF1DD9A0).withOpacity(0.1) : const Color(0xFF0B1221),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: isFeatured ? const Color(0xFF1DD9A0) : Colors.white10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tier['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(tier['price'] as String, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: isFeatured ? const Color(0xFF1DD9A0) : Colors.white)),
                    Text(tier['desc'] as String, style: const TextStyle(fontSize: 10, color: Colors.white54)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static Widget _buildHeader(String title, String icon, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF4D9FFF))),
            ],
          ),
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
