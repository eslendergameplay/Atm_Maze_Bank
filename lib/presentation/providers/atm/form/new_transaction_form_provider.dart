import 'package:atm_app/config/config.dart';
import 'package:atm_app/infraestructure/inputs/inputs.dart';
import 'package:atm_app/presentation/providers/atm/atm_provider.dart';
import 'package:atm_app/presentation/providers/auth/auth_provider.dart';
import 'package:formz/formz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_transaction_form_provider.g.dart';

class NewTransactionFormState {
  final List<AtmUser> users;
  final AtmUser selectedUser;
  final Amount amount;
  final double balance;
  final bool isValid;
  final bool isFormPosted;
  final bool isPosting;

  NewTransactionFormState({
    this.users = const [],
    this.selectedUser = const AtmUser(),
    this.amount = const Amount.pure(),
    this.balance = 0.0,
    this.isValid = false,
    this.isFormPosted = false,
    this.isPosting = false,
  });

  bool get hasDestination =>
      users.any((user) => user.identification == selectedUser.identification);

  NewTransactionFormState copyWith({
    List<AtmUser>? users,
    AtmUser? selectedUser,
    Amount? amount,
    double? balance,
    bool? isValid,
    bool? isFormPosted,
    bool? isPosting,
  }) => NewTransactionFormState(
    users: users ?? this.users,
    selectedUser: selectedUser ?? this.selectedUser,
    amount: amount ?? this.amount,
    balance: balance ?? this.balance,
    isValid: isValid ?? this.isValid,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isPosting: isPosting ?? this.isPosting,
  );
}

@riverpod
class NewTransactionForm extends _$NewTransactionForm {
  @override
  NewTransactionFormState build() {
    final authState = ref.read(authProvider);
    final AtmUser current = ref.read(atmProvider).user ?? const AtmUser();

    final destinations = authState.users
        .where((user) => user.identification != current.identification)
        .toList();

    return NewTransactionFormState(
      users: destinations,
      balance: current.balance,
    );
  }

  void onSelectedUserChanged(String identification) {
    AtmUser? selected;
    for (final AtmUser user in state.users) {
      if (user.identification == identification) {
        selected = user;
        break;
      }
    }
    if (selected == null) return;

    state = state.copyWith(selectedUser: selected);
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
    if (!state.isValid || !state.hasDestination) {
      state = state.copyWith(isFormPosted: true);
      return false;
    }

    state = state.copyWith(isPosting: true, isFormPosted: true);
    ref.read(atmProvider.notifier).clearMessage();
    try {
      return await ref
          .read(atmProvider.notifier)
          .transfer(state.selectedUser.identification, _amountValue());
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
