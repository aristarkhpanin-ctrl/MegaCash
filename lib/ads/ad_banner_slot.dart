import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_dimens.dart';
import 'ads_provider.dart';

final adsProvider = Provider<AdsProvider>((ref) {
  const ads = NoAdsProvider();
  ref.onDispose(ads.dispose);
  return ads;
});

/// Место под баннер.
///
/// Если рекламы нет — место схлопывается полностью. Пустая рамка вместо
/// баннера выглядит как сломанное приложение и занимает высоту, которая
/// нужнее содержимому.
class AdBannerSlot extends ConsumerWidget {
  const AdBannerSlot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banner = ref.watch(adsProvider).banner(context);
    if (banner == null) return const SizedBox.shrink();

    return SizedBox(
      height: Dimens.adBannerReservedHeight,
      child: Center(
        child: SizedBox(
          width: Dimens.adBannerWidth,
          height: Dimens.adBannerHeight,
          child: banner,
        ),
      ),
    );
  }
}
