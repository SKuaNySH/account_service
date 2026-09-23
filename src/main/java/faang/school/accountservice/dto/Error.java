package faang.school.accountservice.dto;

public record Error(
        String errorType,
        String errorMessage
) {
}
