import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/dark_mode_scope.dart';
import '../../../../core/utils/size_utils.dart';
import '../../../../core/widgets/layout_scope.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../domain/entities/session_config.dart';
import '../bloc/breathing_bloc.dart';
import '../bloc/breathing_event.dart';
import '../widgets/cloud_layer.dart';
import 'breathing_screen.dart';

class PaceScreen extends StatefulWidget {
  const PaceScreen({super.key});

  @override
  State<PaceScreen> createState() => _PaceScreenState();
}

class _PaceScreenState extends State<PaceScreen> {
  int _durationIndex = 1;
  int _roundsIndex = 1;
  bool _soundOn = true;
  bool _advancedExpanded = false;
  int _breatheInSec = 4;
  int _holdInSec = 4;
  int _breatheOutSec = 4;
  int _holdOutSec = 4;

  static const _durations = [3, 4, 5, 6];
  static const _roundsOptions = [
    (2, '2 quick'),
    (4, '4 calm'),
    (6, '6 deep'),
    (8, '8 zen'),
  ];

  int get _simpleDuration => _durations[_durationIndex];

  void _onAdvancedToggled() {
    setState(() {
      _breatheInSec = _simpleDuration;
      _holdInSec = _simpleDuration;
      _breatheOutSec = _simpleDuration;
      _holdOutSec = _simpleDuration;
      _advancedExpanded = !_advancedExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = DarkModeScope.of(context).isDark;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CloudLayer(isDark: isDark),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.getW(2), vertical: context.getH(0.5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? Colors.grey.shade300.withAlpha(9) : Colors.grey.shade300,
                        ),
                        child: IconButton(
                          onPressed: DarkModeScope.of(context).toggleDark,
                          icon: Icon(
                            isDark ? Icons.light_mode : Icons.dark_mode,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: context.getW(5)),
                    child: ResponsiveLayout(
                      mobile: _buildContent(context),
                      web: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: _buildContent(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = DarkModeScope.of(context).isDark;
    final titleColor = isDark ? Colors.white : AppColors.lightPrimary;
    final subColor = isDark ? Colors.white70 : Colors.black38;
    final cardBg = isDark ? AppColors.darkCardBackground : AppColors.lightSurface;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.scaleW(1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: context.scaleH(context.isWeb ? 0 : 1.2)),
          Text(
            'Set up your breathing pace',
            style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: titleColor,
                fontSize: context.scaleSp(28),
            ),
          ),
          SizedBox(height: context.scaleH(context.isWeb ? 1 : 0)),
          Text(
            'Customise your breathing session. You can always change this later.',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey, fontSize: context.scaleSp(16)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.scaleH(2)),
          Container(
            padding: EdgeInsets.all(context.scaleW(context.isWeb ? 2 : 6)),
            margin: EdgeInsets.symmetric(horizontal: context.scaleW(context.isWeb?4:0)),
            decoration: BoxDecoration(
              color: isDark ? cardBg.withValues(alpha: 0.1) : cardBg,
              borderRadius: BorderRadius.circular(context.scaleSp(20)),
              border: isDark
                  ? Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    )
                  : null,
              boxShadow: [
                if (isDark)
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.06),
                    blurRadius: 20,
                    offset: const Offset(-2, -2),
                  ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Breath duration',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                    fontSize: context.scaleSp(16),
                  ),
                ),
                Text(
                  'Seconds per phase',
                  style: theme.textTheme.bodySmall?.copyWith(color: subColor, fontSize: context.scaleSp(14)),
                ),
                SizedBox(height: context.scaleH(2)),
                Wrap(
                  spacing: context.scaleW(2),
                  runSpacing: context.scaleH(1),
                  children: List.generate(4, (i) {
                    final selected = i == _durationIndex;
                    return _ChipOption(
                      label: '${_durations[i]}s',
                      selected: selected,
                      isDark: isDark,
                      onTap: () => setState(() => _durationIndex = i),
                    );
                  }),
                ),
                Padding(
                  padding: EdgeInsets.all(context.scaleW(context.isWeb ? 1 : 4)),
                  child: Divider(thickness: 0.2, color: Colors.grey),
                ),
                Text(
                  'Rounds',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                    fontSize: context.scaleSp(16),
                  ),
                ),
                Text(
                  context.isWeb ? 'Full box breathing cycles' : 'Full breathing cycles',
                  style: theme.textTheme.bodySmall?.copyWith(color: subColor, fontSize: context.scaleSp(14)),
                ),
                SizedBox(height: context.scaleH(2)),
                Wrap(
                  spacing: context.scaleW(2),
                  runSpacing: context.scaleH(1),
                  children: List.generate(4, (i) {
                    final selected = i == _roundsIndex;
                    return _ChipOption(
                      label: _roundsOptions[i].$2,
                      selected: selected,
                      isDark: isDark,
                      onTap: () => setState(() => _roundsIndex = i),
                    );
                  }),
                ),
                Padding(
                  padding: EdgeInsets.all(context.scaleW(context.isWeb ? 1 : 4)),
                  child: Divider(thickness: 0.4, color: Colors.grey),
                ),
                InkWell(
                  onTap: _onAdvancedToggled,
                  borderRadius: BorderRadius.circular(context.scaleW(2)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: context.scaleH(1)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Advanced timing',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: titleColor,
                                  fontSize: context.scaleSp(16),
                                ),
                              ),
                              Text(
                                'Set different durations for each phase',
                                style: theme.textTheme.bodySmall?.copyWith(color: subColor, fontSize: context.scaleSp(14)),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _advancedExpanded ? Icons.expand_less : Icons.expand_more,
                          color: subColor,
                          size: context.scaleSp(24),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_advancedExpanded) ...[
                  SizedBox(height: context.scaleH(1.2)),
                  _PhaseRow(
                    label: 'Breathe in',
                    value: _breatheInSec,
                    isDark: isDark,
                    onMinus: () => setState(() => _breatheInSec = (_breatheInSec - 1).clamp(2, 10)),
                    onPlus: () => setState(() => _breatheInSec = (_breatheInSec + 1).clamp(2, 10)),
                  ),
                  _PhaseRow(
                    label: 'Hold in',
                    value: _holdInSec,
                    isDark: isDark,
                    onMinus: () => setState(() => _holdInSec = (_holdInSec - 1).clamp(2, 10)),
                    onPlus: () => setState(() => _holdInSec = (_holdInSec + 1).clamp(2, 10)),
                  ),
                  _PhaseRow(
                    label: 'Breathe out',
                    value: _breatheOutSec,
                    isDark: isDark,
                    onMinus: () => setState(() => _breatheOutSec = (_breatheOutSec - 1).clamp(2, 10)),
                    onPlus: () => setState(() => _breatheOutSec = (_breatheOutSec + 1).clamp(2, 10)),
                  ),
                  _PhaseRow(
                    label: 'Hold out',
                    value: _holdOutSec,
                    isDark: isDark,
                    onMinus: () => setState(() => _holdOutSec = (_holdOutSec - 1).clamp(2, 10)),
                    onPlus: () => setState(() => _holdOutSec = (_holdOutSec + 1).clamp(2, 10)),
                  ),
                ],
                SizedBox(height: context.scaleH(3)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sound',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: titleColor,
                            fontSize: context.scaleSp(16),
                          ),
                        ),
                        Text(
                          'Gentle chime between phases',
                          style: theme.textTheme.bodySmall?.copyWith(color: subColor, fontSize: context.scaleSp(14)),
                        ),
                      ],
                    ),
                    Switch(
                      value: _soundOn,
                      onChanged: (v) => setState(() => _soundOn = v),
                      activeTrackColor: (isDark ? AppColors.darkAccentPurple : AppColors.lightPrimary),
                      activeThumbColor: isDark ? AppColors.darkBubble : AppColors.lightBubble,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: context.scaleH(4)),
           Padding(
             padding: EdgeInsets.symmetric(horizontal: context.scaleW(context.isWeb?4:0)),
             child: FilledButton.icon(
              onPressed: () {
                final cycles = _roundsOptions[_roundsIndex].$1;
                final d = _advancedExpanded
                    ? (_breatheInSec, _holdInSec, _breatheOutSec, _holdOutSec)
                    : (_simpleDuration, _simpleDuration, _simpleDuration, _simpleDuration);
                final config = SessionConfig(
                  cycles: cycles,
                  breatheInSeconds: d.$1,
                  holdInSeconds: d.$2,
                  breatheOutSeconds: d.$3,
                  holdOutSeconds: d.$4,
                  soundOn: _soundOn,
                );
                context.read<BreathingBloc>().add(StartSession(config: config));
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => const BreathingScreen(),
                  ),
                );
              },
              icon: Icon(Icons.air, size: context.scaleSp(20)),
              iconAlignment: IconAlignment.end,
              label: Text('Start breathing', style: TextStyle(fontSize: context.scaleSp(16), color: Colors.white)),
              style: FilledButton.styleFrom(
                backgroundColor: isDark ? AppColors.darkAccentPurple : AppColors.lightPrimary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 0),
                padding: EdgeInsets.symmetric(vertical: context.scaleH(context.isWeb ? 3.5 : 2)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.scaleW(4))),
              ),
                       ),
           ),
          SizedBox(height: context.scaleH(4)),
        ],
      ),
    );
  }
}

class _ChipOption extends StatelessWidget {
  const _ChipOption({
    required this.label,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? (isDark ? AppColors.lightSelectedOption.withOpacity(0.3) : AppColors.lightSurface)
        : (isDark ? Colors.black : Colors.grey.withOpacity(0.15));
    final borderColor = selected
        ? (isDark ? AppColors.lightSelectedOption : AppColors.lightSelectedOption)
        : (isDark ? Colors.black : Colors.grey.withOpacity(0.15));
    final textColor = selected
        ? (isDark ? AppColors.lightSelectedOption : AppColors.lightSelectedOption)
        : (isDark ? Colors.white38 : Colors.grey);
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(context.scaleSp(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.scaleSp(20)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: context.scaleSp(16), vertical: context.scaleSp(10)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.scaleSp(20)),
            border: Border.all(color: borderColor, width: selected ? 1.5 : 1),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: textColor,
              fontSize: context.scaleSp(14),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhaseRow extends StatelessWidget {
  const _PhaseRow({
    required this.label,
    required this.value,
    required this.isDark,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final int value;
  final bool isDark;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDark ? Colors.white : Colors.black;
    return Padding(
      padding: EdgeInsets.only(bottom: context.scaleSp(8)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(context.scaleSp(8)),
        ),
        padding: EdgeInsets.symmetric(horizontal: context.scaleW(2), vertical: context.scaleH(0.6)),
        child: Row(
          children: [
            SizedBox(width: context.scaleW(25), child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: color, fontSize: context.scaleSp(15), fontWeight: FontWeight.w600))),
            IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: isDark ? Colors.grey : Colors.white,
                foregroundColor: color,
              ),
              onPressed: onMinus,
              icon: Icon(Icons.remove, size: context.scaleSp(18)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.scaleSp(12)),
              child: Text('${value}s', style: theme.textTheme.titleSmall?.copyWith(color: color, fontSize: context.scaleSp(15))),
            ),
            IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: isDark ? Colors.grey : Colors.white,
                foregroundColor: color,
              ),
              onPressed: onPlus,
              icon: Icon(Icons.add, size: context.scaleSp(18)),
            ),
          ],
        ),
      ),
    );
  }
}
