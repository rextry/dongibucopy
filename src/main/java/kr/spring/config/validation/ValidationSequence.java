package kr.spring.config.validation;

import javax.validation.GroupSequence;
import javax.validation.groups.Default;

import kr.spring.config.validation.ValidationGroups.NotNullGroup;
import kr.spring.config.validation.ValidationGroups.PatternCheckGroup;
import kr.spring.config.validation.ValidationGroups.SizeCheckGroup;
import kr.spring.config.validation.ValidationGroups.TypeCheckGroup;

@GroupSequence({Default.class, NotNullGroup.class, TypeCheckGroup.class, SizeCheckGroup.class, PatternCheckGroup.class })
public interface ValidationSequence {
}
