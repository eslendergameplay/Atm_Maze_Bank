import 'package:atm_app/infraestructure/inputs/inputs.dart';
import 'package:atm_app/presentation/providers/atm/atm_provider.dart';
import 'package:formz/formz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_withdraw_form_provider.g.dart';

class NewWithdrawFormState {
  final Amount amount;
  final double balance;
  final bool isValid;
  final bool isFormPosted;
  final bool isPosting;

  NewWithdrawFormState({
    this.amount = const Amount.pure(),
    this.balance = 0.0,
    this.isValid = false,
    this.isFormPosted = false,
    this.isPosting = false,
  });

  NewWithdrawFormState copyWith({
    Amount? amount,
    double? balance,
    bool? isValid,
    bool? isFormPosted,
    bool? isPosting,
  }) => NewWithdrawFormState(
    amount: amount ?? this.amount,
    balance: balance ?? this.balance,
    isValid: isValid ?? this.isValid,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isPosting: isPosting ?? this.isPosting,
  );
}

@riverpod
class NewWithdrawForm extends _$NewWithdrawForm {
  @override
  NewWithdrawFormState build() {
    final balance = ref.read(atmProvider).user?.balance ?? 0.0;
    return NewWithdrawFormState(balance: balance);
  }

  void onAmountChanged(String value) {
    final newAmount = Amount.dirty(value);
    state = state.copyWith(
      amount: newAmount,
      isValid: Formz.validate([newAmount]),
    );
  }

  Future<bool> onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) {
      state = state.copyWith(isFormPosted: true);
      return false;
    }

    state = state.copyWith(isPosting: true, isFormPosted: true);
    ref.read(atmProvider.notifier).clearMessage();
    try {
      return await ref.read(atmProvider.notifier).withdraw(_amountValue());
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isPosting: false);
      }
    }
  }

  void _touchEveryField() {
    final amount = Amount.dirty(state.amount.value);
    state = state.copyWith(amount: amount, isValid: Formz.validate([amount]));
  }

  double _amountValue() =>
      double.tryParse(state.amount.value.replaceAll(',', '.')) ?? 0.0;
}
