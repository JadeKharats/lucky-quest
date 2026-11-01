# A member dresses Quest for herself only.
class ChooseSkin < User::SaveOperation
  param_key :appearance

  permit_columns skin
end
